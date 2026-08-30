import { Difficulty, Discipline, MuscleGroup, TrainingGoal } from '@prisma/client';

/**
 * The exercise directory's content.
 *
 * Written rather than scraped, and deliberately not exhaustive: a member
 * scrolling two hundred variations learns less than one reading twenty
 * they will actually use. Every entry carries the cue that stops the
 * common injury for that movement, because a directory that only lists
 * steps teaches people to do things badly with confidence.
 *
 * English only for now. The schema keeps translations in their own table,
 * so adding Hindi or Tamil later is rows, not a migration.
 */

export interface ExerciseSeed {
  slug: string;
  discipline: Discipline;
  primaryMuscle: MuscleGroup;
  goals: TrainingGoal[];
  difficulty: Difficulty;
  equipment?: string;
  name: string;
  summary: string;
  steps: string[];
  cautions: string[];
}

export const EXERCISES: ExerciseSeed[] = [
  // ── Chest ──────────────────────────────────────────────────────────
  {
    slug: 'barbell-bench-press',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.CHEST,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.STRENGTH],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Barbell and bench',
    name: 'Barbell bench press',
    summary: 'The standard chest press. Builds pressing strength through the whole upper body.',
    steps: [
      'Lie flat with your eyes under the bar and feet planted on the floor.',
      'Grip a little wider than shoulder width, wrists stacked over your forearms.',
      'Pull your shoulder blades together and down into the bench, and hold them there.',
      'Unrack, and lower the bar under control to the base of your chest.',
      'Touch lightly, then press back up and slightly back towards your face.',
    ],
    cautions: [
      'Never bench heavy without a spotter or safety pins.',
      'Keep your shoulder blades pinned. Letting them roll forward is what hurts shoulders here.',
    ],
  },
  {
    slug: 'push-up',
    discipline: Discipline.CALISTHENICS,
    primaryMuscle: MuscleGroup.CHEST,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.GENERAL_FITNESS],
    difficulty: Difficulty.BEGINNER,
    name: 'Push-up',
    summary: 'Chest, shoulders and triceps with nothing but the floor.',
    steps: [
      'Hands under your shoulders, body in one straight line from head to heels.',
      'Squeeze your glutes so your hips do not sag.',
      'Lower until your chest is a fist off the floor, elbows at roughly 45 degrees.',
      'Press back up without letting your hips lead.',
    ],
    cautions: [
      'Flaring your elbows straight out to the sides puts the load on your shoulder joint.',
      'If your lower back dips, do them from your knees until your core catches up.',
    ],
  },
  {
    slug: 'incline-dumbbell-press',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.CHEST,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Dumbbells and an incline bench',
    name: 'Incline dumbbell press',
    summary: 'Presses at an angle, which shifts the work to the upper chest.',
    steps: [
      'Set the bench to about 30 degrees. Steeper turns it into a shoulder press.',
      'Sit back with a dumbbell on each thigh, then kick them up as you lie down.',
      'Start with the weights at chest level, palms facing forward.',
      'Press up until your arms are straight but not locked, then lower slowly.',
    ],
    cautions: ['Do not clash the dumbbells together at the top — it wastes tension and pinches shoulders.'],
  },

  // ── Back ───────────────────────────────────────────────────────────
  {
    slug: 'deadlift',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.STRENGTH, TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.ADVANCED,
    equipment: 'Barbell',
    name: 'Deadlift',
    summary: 'Picking heavy weight off the floor. Trains almost everything behind you.',
    steps: [
      'Stand with the bar over your mid-foot, feet hip width apart.',
      'Hinge at the hips and grip just outside your shins.',
      'Drop your hips until your shins touch the bar, chest up, back flat.',
      'Take the slack out of the bar, then push the floor away rather than pulling.',
      'Stand tall, then reverse the path to put it back down.',
    ],
    cautions: [
      'A rounding lower back is the injury here. Stop the set the rep before your form goes.',
      'Do not bounce reps off the floor. Reset each one.',
    ],
  },
  {
    slug: 'pull-up',
    discipline: Discipline.CALISTHENICS,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.STRENGTH, TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Pull-up bar',
    name: 'Pull-up',
    summary: 'The clearest test of upper body pulling strength there is.',
    steps: [
      'Hang from the bar with hands slightly wider than your shoulders.',
      'Pull your shoulder blades down first, before your arms bend.',
      'Drive your elbows towards your ribs until your chin clears the bar.',
      'Lower all the way down under control.',
    ],
    cautions: [
      'Kicking your legs to get up teaches you nothing. Use a band or the machine instead.',
      'Come down slowly. Dropping from the top is hard on elbows and shoulders.',
    ],
  },
  {
    slug: 'bent-over-row',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.STRENGTH],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Barbell',
    name: 'Bent-over row',
    summary: 'Horizontal pulling. Balances out all the pressing most people do.',
    steps: [
      'Hold the bar at hip height, hands shoulder width apart.',
      'Hinge forward until your torso is around 45 degrees, back flat.',
      'Pull the bar to your belly button, elbows tucked in.',
      'Lower it fully and let your shoulder blades open before the next rep.',
    ],
    cautions: ['Standing up as you pull means the weight is too heavy.'],
  },
  {
    slug: 'lat-pulldown',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Cable machine',
    name: 'Lat pulldown',
    summary: 'A pull-up you can load lighter than your bodyweight while you build up.',
    steps: [
      'Set the thigh pad so you cannot lift off the seat.',
      'Grip wider than your shoulders and lean back slightly.',
      'Pull the bar to your upper chest, leading with your elbows.',
      'Let it rise all the way back up under control.',
    ],
    cautions: ['Never pull the bar behind your neck — it forces the shoulder into a bad position.'],
  },

  // ── Legs ───────────────────────────────────────────────────────────
  {
    slug: 'back-squat',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.QUADS,
    goals: [TrainingGoal.STRENGTH, TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Barbell and rack',
    name: 'Back squat',
    summary: 'The main lower body strength lift.',
    steps: [
      'Set the bar at armpit height and take it across your upper back, not your neck.',
      'Step back, feet shoulder width, toes turned slightly out.',
      'Take a breath into your belly and brace as if about to be punched.',
      'Sit down and back until your hip crease passes your knee.',
      'Drive up through your whole foot, keeping your chest up.',
    ],
    cautions: [
      'Always use safety pins set below your lowest depth.',
      'Knees caving in on the way up means the weight is too heavy or your glutes are not firing.',
    ],
  },
  {
    slug: 'romanian-deadlift',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.HAMSTRINGS,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.STRENGTH],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Barbell or dumbbells',
    name: 'Romanian deadlift',
    summary: 'A hip hinge that loads the hamstrings through their full stretch.',
    steps: [
      'Stand holding the weight at your thighs, knees softly bent.',
      'Push your hips back as if closing a car door behind you.',
      'Let the weight slide down your legs, staying close to them.',
      'Stop when you feel a strong stretch in your hamstrings, then drive your hips forward.',
    ],
    cautions: ['This is a hip hinge, not a squat. If your knees travel forward, you are squatting.'],
  },
  {
    slug: 'walking-lunge',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.GLUTES,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.GENERAL_FITNESS],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Dumbbells (optional)',
    name: 'Walking lunge',
    summary: 'One leg at a time, which exposes and fixes side-to-side differences.',
    steps: [
      'Stand tall, weights at your sides if you are using them.',
      'Step forward far enough that your front shin stays vertical.',
      'Lower until your back knee is just off the floor.',
      'Push through your front heel to stand, and step straight into the next one.',
    ],
    cautions: ['Short steps put the strain on your knee. Step further than feels natural.'],
  },
  {
    slug: 'calf-raise',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.CALVES,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    name: 'Standing calf raise',
    summary: 'Calves respond to full range and high reps more than heavy weight.',
    steps: [
      'Stand with the balls of your feet on a step, heels hanging off.',
      'Drop your heels as far below the step as they will go.',
      'Push up onto your toes as high as you can and pause for a second.',
      'Lower slowly. Take three seconds on the way down.',
    ],
    cautions: ['Bouncing out of the bottom uses the tendon rather than the muscle.'],
  },

  // ── Shoulders and arms ─────────────────────────────────────────────
  {
    slug: 'overhead-press',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.SHOULDERS,
    goals: [TrainingGoal.STRENGTH, TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Barbell',
    name: 'Overhead press',
    summary: 'Pressing straight up. Demands the whole body stay tight.',
    steps: [
      'Hold the bar at collarbone height, hands just outside your shoulders.',
      'Squeeze your glutes and brace your core so your back does not arch.',
      'Move your head back slightly and press the bar straight up past your face.',
      'Finish with the bar over the middle of your feet, biceps by your ears.',
    ],
    cautions: ['Leaning back to get the bar up turns this into a standing incline press and strains the lower back.'],
  },
  {
    slug: 'lateral-raise',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.SHOULDERS,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Dumbbells',
    name: 'Lateral raise',
    summary: 'The one movement that builds shoulder width. Light weight, strict form.',
    steps: [
      'Stand with a light dumbbell in each hand, a slight bend in your elbows.',
      'Raise your arms out to the sides until they are level with your shoulders.',
      'Lead with your elbows, not your hands.',
      'Lower slowly, taking twice as long as the lift.',
    ],
    cautions: ['If you have to swing to lift it, halve the weight. Nearly everyone uses too much here.'],
  },
  {
    slug: 'barbell-curl',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.BICEPS,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Barbell or EZ bar',
    name: 'Barbell curl',
    summary: 'The direct biceps builder.',
    steps: [
      'Stand holding the bar at arms length, palms forward, hands shoulder width.',
      'Keep your elbows pinned at your sides.',
      'Curl the bar up by bending only at the elbow.',
      'Lower all the way until your arms are straight.',
    ],
    cautions: ['Swinging your hips moves the work to your lower back. Stand against a wall if you cannot stop.'],
  },
  {
    slug: 'triceps-pushdown',
    discipline: Discipline.STRENGTH,
    primaryMuscle: MuscleGroup.TRICEPS,
    goals: [TrainingGoal.MUSCLE_GAIN],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Cable machine',
    name: 'Triceps pushdown',
    summary: 'Isolates the triceps with constant tension throughout.',
    steps: [
      'Set the cable at head height with a straight or rope attachment.',
      'Stand close, elbows tucked at your sides.',
      'Push down until your arms are straight, squeezing at the bottom.',
      'Let it rise back to chest height without your elbows drifting forward.',
    ],
    cautions: ['If your elbows travel, you are using your chest and shoulders instead.'],
  },

  // ── Core ───────────────────────────────────────────────────────────
  {
    slug: 'plank',
    discipline: Discipline.CALISTHENICS,
    primaryMuscle: MuscleGroup.CORE,
    goals: [TrainingGoal.GENERAL_FITNESS, TrainingGoal.REHAB],
    difficulty: Difficulty.BEGINNER,
    name: 'Plank',
    summary: 'Trains the core to resist movement, which is its actual job.',
    steps: [
      'Forearms on the floor, elbows under your shoulders.',
      'Body in one line from head to heels, toes tucked.',
      'Squeeze your glutes and tuck your hips slightly under.',
      'Breathe normally. Hold for time rather than counting reps.',
    ],
    cautions: [
      'Sagging hips put the load on your lower back instead of your abs.',
      'Thirty seconds done well beats two minutes done badly.',
    ],
  },
  {
    slug: 'hanging-leg-raise',
    discipline: Discipline.CALISTHENICS,
    primaryMuscle: MuscleGroup.CORE,
    goals: [TrainingGoal.MUSCLE_GAIN, TrainingGoal.STRENGTH],
    difficulty: Difficulty.ADVANCED,
    equipment: 'Pull-up bar',
    name: 'Hanging leg raise',
    summary: 'The hardest common ab movement, and the most effective.',
    steps: [
      'Hang from a bar with your shoulders active, not fully relaxed.',
      'Tilt your pelvis back before your legs move at all.',
      'Raise your legs until they are level with your hips or higher.',
      'Lower slowly without letting yourself swing.',
    ],
    cautions: ['Swinging means your hip flexors are doing it. Bend your knees until you can do it still.'],
  },
  {
    slug: 'dead-bug',
    discipline: Discipline.MOBILITY,
    primaryMuscle: MuscleGroup.CORE,
    goals: [TrainingGoal.REHAB, TrainingGoal.GENERAL_FITNESS],
    difficulty: Difficulty.BEGINNER,
    name: 'Dead bug',
    summary: 'Teaches the core to hold the spine still while the limbs move. Kind to backs.',
    steps: [
      'Lie on your back, arms straight up, knees bent at 90 degrees over your hips.',
      'Press your lower back flat into the floor and keep it there.',
      'Slowly lower one arm overhead and the opposite leg towards the floor.',
      'Return to the start and switch sides.',
    ],
    cautions: ['The moment your lower back lifts off the floor, you have gone too far. Shorten the range.'],
  },

  // ── Cardio ─────────────────────────────────────────────────────────
  {
    slug: 'treadmill-intervals',
    discipline: Discipline.CARDIO,
    primaryMuscle: MuscleGroup.FULL_BODY,
    goals: [TrainingGoal.FAT_LOSS, TrainingGoal.ENDURANCE],
    difficulty: Difficulty.INTERMEDIATE,
    equipment: 'Treadmill',
    name: 'Treadmill intervals',
    summary: 'Short hard efforts with recovery between. More conditioning per minute than steady jogging.',
    steps: [
      'Warm up at an easy walk or jog for five minutes.',
      'Run hard for one minute — quick enough that talking is difficult.',
      'Walk or jog easy for two minutes.',
      'Repeat six to eight times, then cool down for five minutes.',
    ],
    cautions: ['Straddle the belt before raising to a sprint speed, rather than accelerating under your feet.'],
  },
  {
    slug: 'rowing-machine',
    discipline: Discipline.CARDIO,
    primaryMuscle: MuscleGroup.FULL_BODY,
    goals: [TrainingGoal.ENDURANCE, TrainingGoal.FAT_LOSS],
    difficulty: Difficulty.BEGINNER,
    equipment: 'Rowing machine',
    name: 'Rowing machine',
    summary: 'Full body cardio that spares the knees.',
    steps: [
      'Strap your feet in with the strap across the widest part of your foot.',
      'Drive with your legs first, keeping your arms straight.',
      'Once your legs are nearly straight, lean back slightly.',
      'Finally pull the handle to your lower ribs, then reverse the order exactly.',
    ],
    cautions: ['Legs, then back, then arms. Pulling with your arms first is the most common mistake and the least efficient.'],
  },

  // ── Yoga ───────────────────────────────────────────────────────────
  {
    slug: 'surya-namaskar',
    discipline: Discipline.YOGA,
    primaryMuscle: MuscleGroup.FULL_BODY,
    goals: [TrainingGoal.FLEXIBILITY, TrainingGoal.GENERAL_FITNESS],
    difficulty: Difficulty.BEGINNER,
    name: 'Surya Namaskar (Sun Salutation)',
    summary: 'A twelve-step sequence that warms the whole body. A complete practice on its own.',
    steps: [
      'Stand tall with palms together at your chest, and breathe out.',
      'Breathe in and reach your arms overhead, arching gently back.',
      'Breathe out and fold forward, hands towards the floor.',
      'Breathe in and step your right leg back into a low lunge, looking up.',
      'Hold your breath and step the other leg back into a plank.',
      'Breathe out and lower knees, chest and chin to the floor.',
      'Breathe in and slide forward into cobra, chest lifted.',
      'Breathe out and lift your hips into downward dog.',
      'Breathe in and step your right foot forward between your hands.',
      'Breathe out and bring the other foot forward, folding over your legs.',
      'Breathe in and rise, reaching overhead.',
      'Breathe out and return your palms to your chest. That is one round.',
    ],
    cautions: [
      'Bend your knees in the forward folds rather than rounding your lower back.',
      'Build up slowly. Five rounds done with the breath beats twenty rushed.',
    ],
  },
  {
    slug: 'adho-mukha-svanasana',
    discipline: Discipline.YOGA,
    primaryMuscle: MuscleGroup.FULL_BODY,
    goals: [TrainingGoal.FLEXIBILITY, TrainingGoal.REHAB],
    difficulty: Difficulty.BEGINNER,
    name: 'Adho Mukha Svanasana (Downward Dog)',
    summary: 'Lengthens hamstrings, calves and the whole back at once.',
    steps: [
      'Start on hands and knees, hands slightly ahead of your shoulders.',
      'Tuck your toes and lift your hips up and back.',
      'Bend your knees generously at first, and lengthen your spine instead.',
      'Press the floor away and let your heels sink towards it.',
      'Hold for five slow breaths.',
    ],
    cautions: ['Straight legs matter far less than a long spine. Round backs come from forcing the knees straight.'],
  },
  {
    slug: 'virabhadrasana-ii',
    discipline: Discipline.YOGA,
    primaryMuscle: MuscleGroup.QUADS,
    goals: [TrainingGoal.FLEXIBILITY, TrainingGoal.STRENGTH],
    difficulty: Difficulty.BEGINNER,
    name: 'Virabhadrasana II (Warrior II)',
    summary: 'Builds standing leg strength and opens the hips.',
    steps: [
      'Step your feet wide apart, arms out at shoulder height.',
      'Turn your right foot out 90 degrees, left foot slightly in.',
      'Bend your right knee until it is over your ankle, not past it.',
      'Look over your right hand and hold for five breaths, then swap sides.',
    ],
    cautions: ['If your front knee drifts inward or past your toes, widen your stance.'],
  },
  {
    slug: 'balasana',
    discipline: Discipline.YOGA,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.REHAB, TrainingGoal.FLEXIBILITY],
    difficulty: Difficulty.BEGINNER,
    name: "Balasana (Child's Pose)",
    summary: 'A rest that decompresses the lower back. Use it between hard sets, not only in yoga.',
    steps: [
      'Kneel with your big toes together and knees apart.',
      'Sit back onto your heels.',
      'Walk your hands forward and let your forehead rest on the floor.',
      'Breathe into your back ribs for as long as you like.',
    ],
    cautions: ['If your knees complain, put a rolled towel behind them or between heel and hip.'],
  },
  {
    slug: 'setu-bandhasana',
    discipline: Discipline.YOGA,
    primaryMuscle: MuscleGroup.GLUTES,
    goals: [TrainingGoal.REHAB, TrainingGoal.FLEXIBILITY],
    difficulty: Difficulty.BEGINNER,
    name: 'Setu Bandhasana (Bridge Pose)',
    summary: 'Opens the front of the hips and wakes up glutes that sitting has switched off.',
    steps: [
      'Lie on your back, knees bent, feet flat and hip width apart.',
      'Press your feet down and lift your hips towards the ceiling.',
      'Roll your shoulders under and clasp your hands beneath you if it is comfortable.',
      'Hold for five breaths, then lower one vertebra at a time.',
    ],
    cautions: ['Squeeze your glutes rather than arching your lower back to get higher.'],
  },

  // ── Mobility ───────────────────────────────────────────────────────
  {
    slug: 'hip-flexor-stretch',
    discipline: Discipline.MOBILITY,
    primaryMuscle: MuscleGroup.QUADS,
    goals: [TrainingGoal.FLEXIBILITY, TrainingGoal.REHAB],
    difficulty: Difficulty.BEGINNER,
    name: 'Half-kneeling hip flexor stretch',
    summary: 'Undoes what a day at a desk does to your hips. Worth doing before squats.',
    steps: [
      'Kneel on one knee with the other foot flat in front, both at 90 degrees.',
      'Tuck your pelvis under, as if pointing your belt buckle at your chin.',
      'Squeeze the glute on the kneeling side, then ease your hips forward.',
      'Hold for 30 seconds each side.',
    ],
    cautions: ['If you feel it in your lower back rather than the front of your hip, tuck your pelvis harder.'],
  },
  {
    slug: 'thoracic-rotation',
    discipline: Discipline.MOBILITY,
    primaryMuscle: MuscleGroup.BACK,
    goals: [TrainingGoal.FLEXIBILITY, TrainingGoal.REHAB],
    difficulty: Difficulty.BEGINNER,
    name: 'Open book rotation',
    summary: 'Restores upper back rotation, which most shoulder problems are hiding behind.',
    steps: [
      'Lie on your side with knees bent up to 90 degrees, arms straight out in front.',
      'Keep your knees stacked and pinned to the floor.',
      'Open your top arm across your body like turning a page, following it with your eyes.',
      'Breathe out at the end and let your chest sink. Ten each side.',
    ],
    cautions: ['Let your knees roll and the rotation comes from your lower back instead, which is not the point.'],
  },
];
