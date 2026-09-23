import { NextResponse } from 'next/server';

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
  options: QuestionOption[];
}

const allCategoryQuestions: Record<string, CategoryQuestion[]> = {
  'cat-dslr': [
    {
      id: 'cam-power',
      categoryId: 'cat-dslr',
      question: 'Does the camera power on & shoot normally?',
      subtext: 'Check sensor readout, shutter mechanism, dials and screen.',
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
      options: [
        { id: 'opt-bod-1', label: 'Like New / Flawless', sublabel: 'No scratches, firm rubber grips', adj: 1500 },
        { id: 'opt-bod-2', label: 'Good (Minor Rub Marks)', sublabel: 'Normal cosmetic edge wear', adj: 0 },
        { id: 'opt-bod-3', label: 'Heavy Paint Wear / Peeling', sublabel: 'Loose rubber or body dings', adj: -3500 },
      ],
    },
    {
      id: 'cam-accessories',
      categoryId: 'cat-dslr',
      question: 'Original Accessories Included?',
      subtext: 'Box, battery, charging adapter, and body cap.',
      options: [
        { id: 'opt-acc-1', label: 'Full Box + Charger + 2 Batteries', sublabel: 'Complete packaging & caps', adj: 2500 },
        { id: 'opt-acc-2', label: 'Original Charger + 1 Battery', sublabel: 'Basic working bundle', adj: 0 },
        { id: 'opt-acc-3', label: 'Third-Party Charger Only', sublabel: 'No original box/charger', adj: -2000 },
      ],
    },
    {
      id: 'cam-shutter',
      categoryId: 'cat-dslr',
      question: 'Estimated Shutter Actuations?',
      subtext: 'Total photos clicked with this camera body.',
      options: [
        { id: 'opt-shu-1', label: '< 20,000 Shutter Count', sublabel: 'Light hobbyist usage', adj: 1500 },
        { id: 'opt-shu-2', label: '20,000 - 60,000 Shutter Count', sublabel: 'Moderate regular use', adj: 0 },
        { id: 'opt-shu-3', label: '> 80,000 Shutter Count', sublabel: 'Heavy professional workload', adj: -4000 },
      ],
    },
  ],
  'cat-smartphone': [
    {
      id: 'phone-screen',
      categoryId: 'cat-smartphone',
      question: 'Display & Touchscreen Status?',
      subtext: 'Check touch sensitivity, lines, and glass condition.',
      options: [
        { id: 'opt-scr-1', label: 'Original Flawless Screen', sublabel: 'Zero scratches, perfect TrueTone/120Hz', adj: 2000 },
        { id: 'opt-scr-2', label: 'Minor Hairline Scratches', sublabel: 'Touch & display 100% functional', adj: 0 },
        { id: 'opt-scr-3', label: 'Cracked Glass / Black Dots', sublabel: 'Display bleeding or lines', adj: -6000 },
      ],
    },
    {
      id: 'phone-body',
      categoryId: 'cat-smartphone',
      question: 'Back Glass & Metal Frame?',
      subtext: 'Inspect chassis corners, antenna bands, and camera ring.',
      options: [
        { id: 'opt-pbod-1', label: 'Mint / Pristine Condition', sublabel: 'Always used in case', adj: 1000 },
        { id: 'opt-pbod-2', label: 'Minor Edge Dents / Scratches', sublabel: 'Standard daily wear', adj: 0 },
        { id: 'opt-pbod-3', label: 'Cracked Back Glass / Bent', sublabel: 'Chassis damage', adj: -3500 },
      ],
    },
    {
      id: 'phone-battery',
      categoryId: 'cat-smartphone',
      question: 'Battery Health Percentage?',
      subtext: 'Battery maximum capacity percentage in device settings.',
      options: [
        { id: 'opt-pbat-1', label: '90% - 100% Health', sublabel: 'Excellent battery longevity', adj: 1500 },
        { id: 'opt-pbat-2', label: '80% - 89% Health', sublabel: 'Standard operational health', adj: 0 },
        { id: 'opt-pbat-3', label: 'Below 80% / Service Alert', sublabel: 'Requires battery replacement', adj: -3000 },
      ],
    },
    {
      id: 'phone-hardware',
      categoryId: 'cat-smartphone',
      question: 'Cameras, FaceID & Microphones?',
      subtext: 'Test optical zoom, selfie camera, FaceID and speakers.',
      options: [
        { id: 'opt-phw-1', label: 'All Cameras & Sensors Perfect', sublabel: '0.5x, 1x, 3x, FaceID 100%', adj: 0 },
        { id: 'opt-phw-2', label: 'FaceID / Fingerprint Failure', sublabel: 'Biometric sensor unavailable', adj: -3000 },
        { id: 'opt-phw-3', label: 'Camera Shaking / Foggy Lens', sublabel: 'OIS motor or lens flaw', adj: -4500 },
      ],
    },
  ],
  'cat-laptop': [
    {
      id: 'lap-display',
      categoryId: 'cat-laptop',
      question: 'Screen & Retina Coating?',
      subtext: 'Check for keyboard marks, dead pixels, or delamination.',
      options: [
        { id: 'opt-ldisp-1', label: 'Pristine Flawless Display', sublabel: 'No dead pixels or delamination', adj: 1500 },
        { id: 'opt-ldisp-2', label: 'Keyboard Imprints / Micro Scratches', sublabel: 'Visible only under direct light', adj: 0 },
        { id: 'opt-ldisp-3', label: 'Cracked Panel / Lines / Stain', sublabel: 'Screen replacement needed', adj: -7000 },
      ],
    },
    {
      id: 'lap-keyboard',
      categoryId: 'cat-laptop',
      question: 'Keyboard & Trackpad Condition?',
      subtext: 'Test all keys, backlight, and Force Touch / trackpad click.',
      options: [
        { id: 'opt-lkb-1', label: 'All Keys & Touchpad Perfect', sublabel: 'Smooth typing & gestures', adj: 0 },
        { id: 'opt-lkb-2', label: 'Sticky / Stiff Keys', sublabel: 'Minor key resistance', adj: -2500 },
        { id: 'opt-lkb-3', label: 'Trackpad Click Defect', sublabel: 'Click or haptic unresponsive', adj: -4000 },
      ],
    },
    {
      id: 'lap-battery',
      categoryId: 'cat-laptop',
      question: 'Battery Health & Charger?',
      subtext: 'Check battery cycle count and original high-wattage power adapter.',
      options: [
        { id: 'opt-lbat-1', label: 'Original Charger + High Health', sublabel: 'Holds charge 6+ hours', adj: 2000 },
        { id: 'opt-lbat-2', label: 'Normal Battery Health', sublabel: 'Holds charge 3-5 hours', adj: 0 },
        { id: 'opt-lbat-3', label: 'Service Battery Warning', sublabel: 'Requires replacement', adj: -4000 },
      ],
    },
    {
      id: 'lap-body',
      categoryId: 'cat-laptop',
      question: 'Aluminum Body & Hinges?',
      subtext: 'Inspect hinge tension, lid alignment, and port wear.',
      options: [
        { id: 'opt-lbod-1', label: 'Mint / Solid Hinges', sublabel: 'Smooth opening & closing', adj: 1500 },
        { id: 'opt-lbod-2', label: 'Minor Edge Scuffs', sublabel: 'Cosmetic edge rub', adj: 0 },
        { id: 'opt-lbod-3', label: 'Heavy Dent / Loose Hinge', sublabel: 'Chassis deformity', adj: -4500 },
      ],
    },
  ],
  'cat-lens': [
    {
      id: 'lens-glass',
      categoryId: 'cat-lens',
      question: 'Optical Glass & Coating Condition?',
      subtext: 'Look through front & rear elements against strong light.',
      options: [
        { id: 'opt-lensg-1', label: 'Crystal Clear (No Fungus/Scratches)', sublabel: 'Flawless optical glass', adj: 2000 },
        { id: 'opt-lensg-2', label: 'Minor Dust Specks (No Effect on Image)', sublabel: 'Normal internal micro-dust', adj: 0 },
        { id: 'opt-lensg-3', label: 'Visible Fungus / Deep Scratch', sublabel: 'Internal coating haze or fungus', adj: -5500 },
      ],
    },
    {
      id: 'lens-motor',
      categoryId: 'cat-lens',
      question: 'Autofocus & Aperture Blades?',
      subtext: 'Check AF lock speed and aperture actuation.',
      options: [
        { id: 'opt-lensm-1', label: 'Fast Silent AF & Snappy Aperture', sublabel: '100% operational', adj: 0 },
        { id: 'opt-lensm-2', label: 'Sluggish AF / Stiff Focus Ring', sublabel: 'Slow motor response', adj: -2500 },
        { id: 'opt-lensm-3', label: 'AF Hunting Failure / Oily Blades', sublabel: 'Aperture stickiness', adj: -4500 },
      ],
    },
    {
      id: 'lens-accessories',
      categoryId: 'cat-lens',
      question: 'Included Lens Accessories?',
      subtext: 'Original front cap, rear cap, hood, and pouch.',
      options: [
        { id: 'opt-lensa-1', label: 'Full Box + Hood + Front & Rear Caps', sublabel: 'Complete original bundle', adj: 1500 },
        { id: 'opt-lensa-2', label: 'Front & Rear Caps Only', sublabel: 'Basic essential protection', adj: 0 },
        { id: 'opt-lensa-3', label: 'Missing Lens Caps', sublabel: 'No caps included', adj: -1000 },
      ],
    },
  ],
};

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const categoryId = searchParams.get('categoryId') || 'cat-dslr';

    // Map video / action / gimbal to closest camera group or fallback
    let questions = allCategoryQuestions[categoryId];
    if (!questions) {
      if (categoryId === 'cat-video-camera' || categoryId === 'cat-action-camera' || categoryId === 'cat-gimbal') {
        questions = allCategoryQuestions['cat-dslr'];
      } else if (categoryId === 'cat-tablet') {
        questions = allCategoryQuestions['cat-smartphone'];
      } else {
        questions = allCategoryQuestions['cat-dslr'];
      }
    }

    return NextResponse.json({
      success: true,
      categoryId,
      questions,
      total: questions.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch diagnostic questions' },
      { status: 500 }
    );
  }
}
