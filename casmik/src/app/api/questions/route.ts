import { NextResponse } from 'next/server';
import { getCollection } from '@/lib/mongodb';

export const dynamic = 'force-dynamic';

export interface QuestionOption {
  id: string;
  label: string;
  sublabel: string;
  adj: number;
}

export interface CategoryQuestion {
  id: string;
  categoryId: string;
  question: string;
  subtext: string;
  active?: boolean;
  options: QuestionOption[];
}

const defaultCategoryQuestions: Record<string, CategoryQuestion[]> = {
  'cat-dslr': [
    {
      id: 'cam-power',
      categoryId: 'cat-dslr',
      question: 'Does the camera power on & shoot normally?',
      subtext: 'Check sensor readout, shutter mechanism, dials and screen.',
      active: true,
      options: [
        { id: 'opt-pow-1', label: 'Powers on & Shoots Perfectly', sublabel: 'Normal shutter response & dials', adj: 0 },
        { id: 'opt-pow-2', label: 'Intermittent Shutter Lag', sublabel: 'Takes photos but occasional pause', adj: -3000 },
        { id: 'opt-pow-3', label: 'Does Not Power On', sublabel: 'Requires servicing / board check', adj: -8000 },
      ],
    },
    {
      id: 'cam-sensor',
      categoryId: 'cat-dslr',
      question: 'Sensor Glass & Viewfinder Condition?',
      subtext: 'Check sensor surface under direct light.',
      active: true,
      options: [
        { id: 'opt-sen-1', label: 'Pristine Flawless Sensor', sublabel: 'Zero spots, dust or scratches', adj: 2000 },
        { id: 'opt-sen-2', label: 'Minor Dust (Easily Cleaned)', sublabel: 'Standard sensor dust specks', adj: 0 },
        { id: 'opt-sen-3', label: 'Visible Scratches / Fungus', sublabel: 'Coating damage or fungus mark', adj: -5000 },
      ],
    },
    {
      id: 'cam-body',
      categoryId: 'cat-dslr',
      question: 'Body Cosmetic & Rubber Grip Condition?',
      subtext: 'Inspect body corners, tripod mount, and rubber grip.',
      active: true,
      options: [
        { id: 'opt-bod-1', label: 'Like New / Flawless', sublabel: 'No scratches, firm rubber grips', adj: 1500 },
        { id: 'opt-bod-2', label: 'Good (Minor Rub Marks)', sublabel: 'Normal cosmetic edge wear', adj: 0 },
        { id: 'opt-bod-3', label: 'Heavy Paint Wear / Peeling', sublabel: 'Loose rubber or body dings', adj: -3500 },
      ],
    },
    {
      id: 'cam-shutter',
      categoryId: 'cat-dslr',
      question: 'Estimated Shutter Actuations?',
      subtext: 'Total photos clicked with this camera body.',
      active: true,
      options: [
        { id: 'opt-shu-1', label: '< 20,000 Shutter Count', sublabel: 'Light hobbyist usage', adj: 1500 },
        { id: 'opt-shu-2', label: '20,000 - 60,000 Shutter Count', sublabel: 'Moderate regular use', adj: 0 },
        { id: 'opt-shu-3', label: '> 80,000 Shutter Count', sublabel: 'Heavy professional workload', adj: -4000 },
      ],
    },
    {
      id: 'cam-display',
      categoryId: 'cat-dslr',
      question: 'LCD Screen & Articulation / Touch?',
      subtext: 'Check screen tilt mechanism, touch response, and scratch marks.',
      active: true,
      options: [
        { id: 'opt-disp-1', label: 'Flawless Scratch-Free LCD', sublabel: 'Zero screen blemishes', adj: 1000 },
        { id: 'opt-disp-2', label: 'Hairline Micro Scratches', sublabel: 'Visible only under direct light', adj: 0 },
        { id: 'opt-disp-3', label: 'Cracked Glass / Hinge Loose', sublabel: 'Display damage or loose bracket', adj: -4000 },
      ],
    },
    {
      id: 'cam-hardware',
      categoryId: 'cat-dslr',
      question: 'Buttons, Dials & Mount Interface?',
      subtext: 'Test all command dials, joystick, hotshoe, and SD card door.',
      active: true,
      options: [
        { id: 'opt-hw-1', label: 'All Dials & Slots 100% Crisp', sublabel: 'Perfect tactile feedback', adj: 0 },
        { id: 'opt-hw-2', label: 'Loose Port Rubber / Sticky Dial', sublabel: 'Minor physical wear', adj: -1500 },
        { id: 'opt-hw-3', label: 'Card Slot Error / Dial Unresponsive', sublabel: 'Hardware repair required', adj: -4500 },
      ],
    },
    {
      id: 'cam-water',
      categoryId: 'cat-dslr',
      question: 'Moisture, Sand or Fungus Exposure?',
      subtext: 'Check inside battery compartment and lens mount for corrosion or fungus.',
      active: true,
      options: [
        { id: 'opt-wat-1', label: 'Clean Studio Used (Zero Moisture)', sublabel: 'Dry environment maintained', adj: 0 },
        { id: 'opt-wat-2', label: 'Rain / Humidity Exposure', sublabel: 'Minor internal moisture trace', adj: -3500 },
        { id: 'opt-wat-3', label: 'Submerged / Salt Water Contact', sublabel: 'Severe internal corrosion risk', adj: -12000 },
      ],
    },
    {
      id: 'cam-accessories',
      categoryId: 'cat-dslr',
      question: 'Original Charger, Battery & Packaging Box?',
      subtext: 'Original OEM battery, dedicated charger, body cap, and retail box.',
      active: true,
      options: [
        { id: 'opt-acc-1', label: 'Complete Original Box + OEM Charger + Battery', sublabel: 'Complete retail bundle', adj: 2500 },
        { id: 'opt-acc-2', label: 'Original Charger + Battery (No Box)', sublabel: 'Standard operational gear', adj: 0 },
        { id: 'opt-acc-3', label: 'Third-Party Charger Only / Missing Caps', sublabel: 'Incomplete accessory bundle', adj: -2500 },
      ],
    },
  ],
  'cat-smartphone': [
    {
      id: 'phone-power',
      categoryId: 'cat-smartphone',
      question: 'Does the device turn on & stay awake?',
      subtext: 'Press the power button to verify device boots and stays powered.',
      active: true,
      options: [
        { id: 'opt-ppow-1', label: 'Yes, Turns on & Works Normally', sublabel: 'Boots cleanly to home screen', adj: 0 },
        { id: 'opt-ppow-2', label: 'Restarts Frequently / Boot Loops', sublabel: 'Software or motherboard issue', adj: -8000 },
        { id: 'opt-ppow-3', label: 'Dead / Does Not Power On', sublabel: 'Completely unpowered unit', adj: -18000 },
      ],
    },
    {
      id: 'phone-display',
      categoryId: 'cat-smartphone',
      question: 'How is your display & touchscreen?',
      subtext: 'Check for cracks, dead pixels, lines, or touch ghosting.',
      active: true,
      options: [
        { id: 'opt-pdisp-1', label: 'Flawless (No Scratches / Original)', sublabel: 'Zero marks, original panel', adj: 2000 },
        { id: 'opt-pdisp-2', label: 'Minor Hairline Scratches', sublabel: 'Not visible during everyday use', adj: 0 },
        { id: 'opt-pdisp-3', label: 'Deep Scratches / Minor Glass Crack', sublabel: 'Touch working but glass chipped', adj: -4500 },
        { id: 'opt-pdisp-4', label: 'Broken Panel / Lines / Bleeding', sublabel: 'Panel replacement needed', adj: -10000 },
      ],
    },
    {
      id: 'phone-body',
      categoryId: 'cat-smartphone',
      question: 'How is the body condition & metal frame?',
      subtext: 'Dents, deep scuffs, bent frame, or cracked back glass.',
      active: true,
      options: [
        { id: 'opt-pbod-1', label: 'Like New (Always in Case)', sublabel: 'Zero scratches or frame dings', adj: 1500 },
        { id: 'opt-pbod-2', label: 'Good (Minor Edge Rub Marks)', sublabel: 'Normal everyday pocket wear', adj: 0 },
        { id: 'opt-pbod-3', label: 'Multiple Dents / Scratches', sublabel: 'Visible body impacts', adj: -2500 },
        { id: 'opt-pbod-4', label: 'Cracked Back Glass / Bent Chassis', sublabel: 'Structural frame damage', adj: -6000 },
      ],
    },
    {
      id: 'phone-battery',
      categoryId: 'cat-smartphone',
      question: 'Is battery maximum capacity above 85%?',
      subtext: 'Check Settings -> Battery -> Battery Health on iPhone/Android.',
      active: true,
      options: [
        { id: 'opt-pbat-1', label: 'Yes, 90% – 100% Health', sublabel: 'Outstanding full-day endurance', adj: 2000 },
        { id: 'opt-pbat-2', label: '80% – 89% Health (Normal)', sublabel: 'Standard healthy battery life', adj: 0 },
        { id: 'opt-pbat-3', label: 'Below 80% / Service Alert', sublabel: 'Battery replacement prompt shown', adj: -3000 },
      ],
    },
    {
      id: 'phone-functional',
      categoryId: 'cat-smartphone',
      question: 'Are all cameras, FaceID & sensors working?',
      subtext: 'Test optical zoom, selfie camera, FaceID/TouchID, speakers and mic.',
      active: true,
      options: [
        { id: 'opt-pfunc-1', label: 'Everything Works 100% Perfectly', sublabel: 'All cameras & biometrics verified', adj: 0 },
        { id: 'opt-pfunc-2', label: 'Minor Issue (e.g. FaceID or Speaker Muffled)', sublabel: 'One feature non-functional', adj: -3500 },
        { id: 'opt-pfunc-3', label: 'Major Issue (Camera Shaking / No Sound)', sublabel: 'Multiple hardware faults', adj: -7500 },
      ],
    },
    {
      id: 'phone-water',
      categoryId: 'cat-smartphone',
      question: 'Has the device ever had water exposure?',
      subtext: 'Check SIM tray liquid contact indicator (LDI) or internal moisture.',
      active: true,
      options: [
        { id: 'opt-pwat-1', label: 'No Water Damage (Never Submerged)', sublabel: 'Completely dry and clean', adj: 0 },
        { id: 'opt-pwat-2', label: 'Yes, Water Contact / Red LDI Indicator', sublabel: 'Internal corrosion risk', adj: -12000 },
      ],
    },
    {
      id: 'phone-charger',
      categoryId: 'cat-smartphone',
      question: 'Do you have the original charger / cable?',
      subtext: 'Original branded charger and fast-charging cable.',
      active: true,
      options: [
        { id: 'opt-pchg-1', label: 'Yes, Original Fast Charger & Cable', sublabel: 'Original high-wattage gear', adj: 600 },
        { id: 'opt-pchg-2', label: 'No Charger / Cable Only', sublabel: 'Charger brick not provided', adj: 0 },
      ],
    },
    {
      id: 'phone-box',
      categoryId: 'cat-smartphone',
      question: 'Do you have the original retail box?',
      subtext: 'Original manufacturer box with matching IMEI number sticker.',
      active: true,
      options: [
        { id: 'opt-pbox-1', label: 'Yes, Original Box with Matching IMEI', sublabel: 'Verified genuine packaging', adj: 500 },
        { id: 'opt-pbox-2', label: 'No Original Box', sublabel: 'Device only without retail box', adj: 0 },
      ],
    },
  ],
  'cat-laptop': [
    {
      id: 'lap-power',
      categoryId: 'cat-laptop',
      question: 'Does the laptop boot into OS and sleep/wake normally?',
      subtext: 'Powers on without chime failure or unexpected shutdowns.',
      active: true,
      options: [
        { id: 'opt-lpow-1', label: 'Boots Fast & Runs Normal', sublabel: 'No kernel panics or blue screens', adj: 0 },
        { id: 'opt-lpow-2', label: 'Random Shutdowns / Freezes', sublabel: 'Thermal or logic board issue', adj: -7000 },
        { id: 'opt-lpow-3', label: 'No Power / Black Screen Only', sublabel: 'Major motherboard failure', adj: -20000 },
      ],
    },
    {
      id: 'lap-display',
      categoryId: 'cat-laptop',
      question: 'Screen & Anti-Reflective Coating Condition?',
      subtext: 'Check for keyboard marks, dead pixels, staingate, or lines.',
      active: true,
      options: [
        { id: 'opt-ldisp-1', label: 'Pristine Flawless Display', sublabel: 'No dead pixels or delamination', adj: 2000 },
        { id: 'opt-ldisp-2', label: 'Keyboard Imprints / Micro Scratches', sublabel: 'Visible only under direct light', adj: 0 },
        { id: 'opt-ldisp-3', label: 'Cracked Panel / Lines / Staingate', sublabel: 'Screen replacement needed', adj: -8500 },
      ],
    },
    {
      id: 'lap-keyboard',
      categoryId: 'cat-laptop',
      question: 'Keyboard, Backlight & Trackpad Condition?',
      subtext: 'Test all keys, backlight uniformity, and trackpad haptic click.',
      active: true,
      options: [
        { id: 'opt-lkb-1', label: 'All Keys & Touchpad Perfect', sublabel: 'Smooth typing & gestures', adj: 0 },
        { id: 'opt-lkb-2', label: 'Sticky / Stiff Keys', sublabel: 'Minor key resistance', adj: -2500 },
        { id: 'opt-lkb-3', label: 'Trackpad Defect / Broken Backlight', sublabel: 'Click or haptic unresponsive', adj: -4500 },
      ],
    },
    {
      id: 'lap-body',
      categoryId: 'cat-laptop',
      question: 'Aluminum Body, Hinges & Corners?',
      subtext: 'Inspect hinge tension, lid alignment, port wear, and bottom plate.',
      active: true,
      options: [
        { id: 'opt-lbod-1', label: 'Mint / Solid Hinges', sublabel: 'Smooth opening & closing', adj: 1500 },
        { id: 'opt-lbod-2', label: 'Minor Edge Scuffs', sublabel: 'Cosmetic edge rub', adj: 0 },
        { id: 'opt-lbod-3', label: 'Heavy Dent / Loose Hinge', sublabel: 'Chassis deformity', adj: -4500 },
      ],
    },
    {
      id: 'lap-battery',
      categoryId: 'cat-laptop',
      question: 'Battery Health & Cycle Performance?',
      subtext: 'Check battery cycle count and backup duration.',
      active: true,
      options: [
        { id: 'opt-lbat-1', label: 'Original Battery with 6+ Hours Backup', sublabel: 'Excellent battery longevity', adj: 2000 },
        { id: 'opt-lbat-2', label: 'Normal Battery Backup (3-5 Hours)', sublabel: 'Standard usable condition', adj: 0 },
        { id: 'opt-lbat-3', label: 'Service Battery Warning / Swollen', sublabel: 'Immediate replacement needed', adj: -5000 },
      ],
    },
    {
      id: 'lap-hardware',
      categoryId: 'cat-laptop',
      question: 'Webcam, Speakers, Wi-Fi & USB Ports?',
      subtext: 'Check microphone, headphone jack, Thunderbolt/USB-C ports.',
      active: true,
      options: [
        { id: 'opt-lhw-1', label: 'All Ports, Speakers & Webcam Crisp', sublabel: '100% operational hardware', adj: 0 },
        { id: 'opt-lhw-2', label: 'One Loose USB Port or Crackly Speaker', sublabel: 'Minor hardware wear', adj: -2500 },
        { id: 'opt-lhw-3', label: 'Wi-Fi / Webcam Defect', sublabel: 'Internal ribbon cable failure', adj: -4500 },
      ],
    },
    {
      id: 'lap-charger',
      categoryId: 'cat-laptop',
      question: 'Original High-Wattage Power Adapter?',
      subtext: 'Original MagSafe or USB-C power brick with cable.',
      active: true,
      options: [
        { id: 'opt-lchg-1', label: 'Original OEM Fast Charger Included', sublabel: 'Genuine branded charger', adj: 1000 },
        { id: 'opt-lchg-2', label: 'Third-Party Charger / No Charger', sublabel: 'Missing genuine power adapter', adj: -1500 },
      ],
    },
    {
      id: 'lap-box',
      categoryId: 'cat-laptop',
      question: 'Original Packaging Box Available?',
      subtext: 'Original branded box with matching serial numbers.',
      active: true,
      options: [
        { id: 'opt-lbox-1', label: 'Yes, Original Retail Box Included', sublabel: 'Complete packaging available', adj: 600 },
        { id: 'opt-lbox-2', label: 'No Original Box', sublabel: 'Laptop and charger only', adj: 0 },
      ],
    },
  ],
  'cat-lens': [
    {
      id: 'lens-glass',
      categoryId: 'cat-lens',
      question: 'Optical Glass & Coating Condition?',
      subtext: 'Look through front & rear elements against strong light.',
      active: true,
      options: [
        { id: 'opt-lensg-1', label: 'Crystal Clear (No Fungus/Scratches)', sublabel: 'Flawless optical glass', adj: 2000 },
        { id: 'opt-lensg-2', label: 'Minor Dust Specks (No Effect on Image)', sublabel: 'Normal internal micro-dust', adj: 0 },
        { id: 'opt-lensg-3', label: 'Visible Fungus / Deep Scratch', sublabel: 'Internal coating haze or fungus', adj: -5500 },
      ],
    },
    {
      id: 'lens-motor',
      categoryId: 'cat-lens',
      question: 'Autofocus & Manual Focus Ring?',
      subtext: 'Check AF lock speed, accuracy, and focus ring smoothness.',
      active: true,
      options: [
        { id: 'opt-lensm-1', label: 'Fast Silent AF & Smooth Focus Ring', sublabel: '100% operational', adj: 0 },
        { id: 'opt-lensm-2', label: 'Sluggish AF / Stiff Focus Ring', sublabel: 'Slow motor response', adj: -2500 },
        { id: 'opt-lensm-3', label: 'AF Hunting Failure / Motor Dead', sublabel: 'Motor repair required', adj: -5500 },
      ],
    },
    {
      id: 'lens-aperture',
      categoryId: 'cat-lens',
      question: 'Aperture Blades & Electronic Contacts?',
      subtext: 'Inspect aperture actuation and metal mount electrical contacts.',
      active: true,
      options: [
        { id: 'opt-lensap-1', label: 'Snappy Clean Blades (No Oil)', sublabel: 'Instant diaphragm response', adj: 0 },
        { id: 'opt-lensap-2', label: 'Slow Aperture Blades / Oily Trace', sublabel: 'Sticky diaphragm mechanism', adj: -3000 },
        { id: 'opt-lensap-3', label: 'Stuck Aperture / Error 01 Contact', sublabel: 'Blades do not stop down', adj: -6000 },
      ],
    },
    {
      id: 'lens-barrel',
      categoryId: 'cat-lens',
      question: 'Lens Barrel & Rubber Zoom Ring?',
      subtext: 'Inspect metal/plastic barrel finish and rubber zoom ring grip.',
      active: true,
      options: [
        { id: 'opt-lensb-1', label: 'Pristine Barrel & Firm Rubber Ring', sublabel: 'Looks brand new', adj: 1000 },
        { id: 'opt-lensb-2', label: 'Minor Paint Rub / Normal Zoom Feel', sublabel: 'Standard careful usage', adj: 0 },
        { id: 'opt-lensb-3', label: 'Loose Expanded Rubber / Heavy Scuffs', sublabel: 'Cosmetic wear and loose grip', adj: -2000 },
      ],
    },
    {
      id: 'lens-stabilization',
      categoryId: 'cat-lens',
      question: 'Optical Image Stabilization (IS / VR / OSS)?',
      subtext: 'Check if gyro stabilization motor operates quietly without vibration jitter.',
      active: true,
      options: [
        { id: 'opt-lensis-1', label: 'Quiet & Rock-Solid IS Stabilization', sublabel: 'Stabilizer functions perfectly', adj: 0 },
        { id: 'opt-lensis-2', label: 'Buzzing Sound / Jittery Gyro IS', sublabel: 'Stabilizer element struggling', adj: -3500 },
        { id: 'opt-lensis-3', label: 'Lens Does Not Have IS (Non-IS Lens)', sublabel: 'Prime or native unstabilized', adj: 0 },
      ],
    },
    {
      id: 'lens-mount',
      categoryId: 'cat-lens',
      question: 'Metal Bayonet Mount & Weather Gasket?',
      subtext: 'Check mount locking lugs, screw tightness, and rubber weather gasket.',
      active: true,
      options: [
        { id: 'opt-lensmt-1', label: 'Pristine Chrome/Brass Mount & Gasket', sublabel: 'Locks firmly onto camera', adj: 0 },
        { id: 'opt-lensmt-2', label: 'Slight Mount Rub Marks / Torn Gasket', sublabel: 'Minor mount wear', adj: -1000 },
        { id: 'opt-lensmt-3', label: 'Bent Mount Flange / Loose Screws', sublabel: 'Does not mount securely', adj: -4000 },
      ],
    },
    {
      id: 'lens-hood',
      categoryId: 'cat-lens',
      question: 'Original Lens Hood, Front & Rear Caps?',
      subtext: 'Original bayonet lens hood and original brand protective caps.',
      active: true,
      options: [
        { id: 'opt-lensh-1', label: 'Original Hood + Front & Rear Caps', sublabel: 'Complete protective accessories', adj: 1500 },
        { id: 'opt-lensh-2', label: 'Front & Rear Caps Only (No Hood)', sublabel: 'Essential lens protection only', adj: 0 },
        { id: 'opt-lensh-3', label: 'Missing Caps / Third-Party Caps', sublabel: 'No original caps or hood', adj: -1000 },
      ],
    },
    {
      id: 'lens-box',
      categoryId: 'cat-lens',
      question: 'Original Retail Packaging Box & Pouch?',
      subtext: 'Original lens packaging box with foam inserts and soft pouch.',
      active: true,
      options: [
        { id: 'opt-lensbx-1', label: 'Original Box + Factory Pouch Included', sublabel: 'Collector-grade complete package', adj: 1000 },
        { id: 'opt-lensbx-2', label: 'Lens Only (No Original Box)', sublabel: 'Standard lens without outer packaging', adj: 0 },
      ],
    },
  ],
};

// In-memory runtime cache for questions
let inMemoryQuestions: CategoryQuestion[] = Object.values(defaultCategoryQuestions).flat();

async function getOrSeedQuestions(forceReset = false): Promise<CategoryQuestion[]> {
  try {
    const col = await getCollection<CategoryQuestion>('diagnostic_questions');
    let items = await col.find({}).toArray();

    // If empty or force reset, seed all 8 questions per category
    if (forceReset || !items || items.length < 20) {
      const allDefaults = Object.values(defaultCategoryQuestions).flat();
      if (forceReset) {
        await col.deleteMany({});
      }
      for (const q of allDefaults) {
        await col.updateOne({ id: q.id }, { $set: q }, { upsert: true });
      }
      items = await col.find({}).toArray();
    }

    const sanitized = items.map(({ _id, ...rest }: any) => ({
      ...rest,
      active: rest.active !== false,
    }));
    inMemoryQuestions = sanitized;
    return sanitized;
  } catch (err: any) {
    console.warn('MongoDB questions query fallback:', err?.message);
    return inMemoryQuestions;
  }
}

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const categoryId = searchParams.get('categoryId');
    const reset = searchParams.get('reset') === 'true';

    const all = await getOrSeedQuestions(reset);

    if (!categoryId || categoryId === 'all') {
      return NextResponse.json({
        success: true,
        questions: all,
        total: all.length,
        timestamp: new Date().toISOString(),
      });
    }

    // Map video / action / gimbal to closest camera group or fallback
    let mappedCat = categoryId;
    if (!all.some((q) => q.categoryId === mappedCat)) {
      if (categoryId === 'cat-video-camera' || categoryId === 'cat-action-camera' || categoryId === 'cat-gimbal') {
        mappedCat = 'cat-dslr';
      } else if (categoryId === 'cat-tablet') {
        mappedCat = 'cat-smartphone';
      } else {
        mappedCat = 'cat-dslr';
      }
    }

    const filtered = all.filter((q) => q.categoryId === mappedCat && q.active !== false);

    return NextResponse.json({
      success: true,
      categoryId,
      mappedCategory: mappedCat,
      questions: filtered,
      total: filtered.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch diagnostic questions' },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { categoryId, question, subtext, options } = body;

    if (!categoryId || !question) {
      return NextResponse.json(
        { success: false, message: 'categoryId and question are required' },
        { status: 400 }
      );
    }

    const newQuestion: CategoryQuestion = {
      id: body.id || `q-${Date.now()}`,
      categoryId,
      question,
      subtext: subtext || '',
      active: body.active !== false,
      options: Array.isArray(options) ? options : [],
    };

    try {
      const col = await getCollection<CategoryQuestion>('diagnostic_questions');
      await col.insertOne(newQuestion as any);
    } catch (e) {
      console.warn('Mongo insert failed, saved to in-memory:', e);
    }

    inMemoryQuestions.push(newQuestion);

    return NextResponse.json({
      success: true,
      question: newQuestion,
      message: 'Question created successfully',
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to create question' },
      { status: 500 }
    );
  }
}

export async function PUT(request: Request) {
  try {
    const body = await request.json();
    const { id, categoryId, question, subtext, active, options } = body;

    if (!id) {
      return NextResponse.json({ success: false, message: 'Question id is required' }, { status: 400 });
    }

    const updateFields: Partial<CategoryQuestion> = {};
    if (question !== undefined) updateFields.question = question;
    if (subtext !== undefined) updateFields.subtext = subtext;
    if (active !== undefined) updateFields.active = active;
    if (options !== undefined) updateFields.options = options;
    if (categoryId !== undefined) updateFields.categoryId = categoryId;

    try {
      const col = await getCollection<CategoryQuestion>('diagnostic_questions');
      await col.updateOne({ id }, { $set: updateFields });
    } catch (e) {
      console.warn('Mongo update failed, updated in-memory:', e);
    }

    const idx = inMemoryQuestions.findIndex((q) => q.id === id);
    if (idx !== -1) {
      inMemoryQuestions[idx] = { ...inMemoryQuestions[idx], ...updateFields };
    }

    return NextResponse.json({
      success: true,
      message: 'Question updated successfully',
      question: idx !== -1 ? inMemoryQuestions[idx] : { id, ...updateFields },
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to update question' },
      { status: 500 }
    );
  }
}

export async function DELETE(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');

    if (!id) {
      return NextResponse.json({ success: false, message: 'Question id is required' }, { status: 400 });
    }

    try {
      const col = await getCollection<CategoryQuestion>('diagnostic_questions');
      await col.deleteOne({ id });
    } catch (e) {
      console.warn('Mongo delete failed, removed from in-memory:', e);
    }

    inMemoryQuestions = inMemoryQuestions.filter((q) => q.id !== id);

    return NextResponse.json({
      success: true,
      message: 'Question deleted successfully',
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to delete question' },
      { status: 500 }
    );
  }
}
