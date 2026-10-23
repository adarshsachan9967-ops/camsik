import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

// Global subscriber map: partnerId -> Set of controller callbacks across serverless lifecycle
declare global {
  // eslint-disable-next-line no-var
  var __partnerEventSubscribers: Map<string, Set<(data: string) => void>> | undefined;
}

if (!globalThis.__partnerEventSubscribers) {
  globalThis.__partnerEventSubscribers = new Map();
}

const subscribers = globalThis.__partnerEventSubscribers;

export function notifyPartnerOrder(partnerId: string, order: any) {
  const cbs = subscribers.get(partnerId);
  if (cbs && cbs.size > 0) {
    const payload = JSON.stringify({ type: 'new_order_assigned', order });
    cbs.forEach((cb) => {
      try {
        cb(payload);
      } catch {
        // ignore dead subscriber
      }
    });
  }
}

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const partnerId = searchParams.get('partnerId');

  if (!partnerId) {
    return NextResponse.json({ error: 'partnerId is required' }, { status: 400 });
  }

  let sendData: ((data: string) => void) | null = null;

  const stream = new ReadableStream({
    start(controller) {
      sendData = (data: string) => {
        try {
          controller.enqueue(new TextEncoder().encode(`data: ${data}\n\n`));
        } catch {
          // ignore if closed
        }
      };

      if (!subscribers.has(partnerId)) {
        subscribers.set(partnerId, new Set());
      }
      subscribers.get(partnerId)!.add(sendData);

      // Send initial ACK
      controller.enqueue(
        new TextEncoder().encode(
          `data: ${JSON.stringify({ type: 'connected', partnerId, timestamp: new Date().toISOString() })}\n\n`
        )
      );

      // Keepalive ping every 25 seconds
      const pingInterval = setInterval(() => {
        try {
          controller.enqueue(new TextEncoder().encode(': ping\n\n'));
        } catch {
          clearInterval(pingInterval);
        }
      }, 25000);

      request.signal.addEventListener('abort', () => {
        clearInterval(pingInterval);
        if (sendData && subscribers.has(partnerId)) {
          subscribers.get(partnerId)!.delete(sendData);
        }
      });
    },
    cancel() {
      if (sendData && subscribers.has(partnerId)) {
        subscribers.get(partnerId)!.delete(sendData);
      }
    },
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/event-stream; charset=utf-8',
      'Cache-Control': 'no-cache, no-transform',
      'Connection': 'keep-alive',
      'X-Accel-Buffering': 'no',
    },
  });
}
