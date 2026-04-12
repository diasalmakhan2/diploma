import '../models/lesson_content.dart';
import '../models/quiz_question.dart';

const lessons = <LessonContent>[
  LessonContent(
    id: 'listening_night_animals',
    title: 'Listening',
    subtitle: 'Night Animals Song',
    type: LessonType.video,
    accentColor: 0xFF1F7AFC,
    contentTitle: 'Listen, guess, and complete the lyrics',
    contentBody:
        'This lesson is based on the song about owl, raccoon, and wolf. '
        'Students first predict the topic, then choose the main idea, fill in '
        'missing words, and share their opinion.',
    videoAsset: 'assets/videos/night_animals.mp4',
    sections: [
      LessonSection(
        title: 'Pre-listening',
        body:
            'Choose the correct answer.\n'
            '1. What animals might be active at night?\n'
            'A) Lion, elephant, cow\n'
            'B) Owl, raccoon, wolf\n'
            'C) Chicken, sheep, horse\n\n'
            '2. What does an owl usually do at night?\n'
            'A) Sleeps in water\n'
            'B) Hunts and looks around\n'
            'C) Hides underground\n\n'
            '3. What do raccoons like to eat?\n'
            'A) Only grass\n'
            'B) Anything they can find\n'
            'C) Only meat\n\n'
            '4. Wolves usually live in:\n'
            'A) Groups (packs)\n'
            'B) Alone in houses\n'
            'C) Trees',
      ),
      LessonSection(
        title: 'While listening',
        body:
            'Main idea task:\n'
            'The song is about different night animals and what they do.\n\n'
            'Fill in the blanks while listening again:\n'
            'When the night gets dark, here we come\n'
            "It's our _______\n"
            'I am an owl with a unique neck\n'
            'Believe it or not\n'
            'I can turn my face _______ down\n'
            'I look all around, underneath the _______\n'
            'I am a raccoon with a _______\n'
            "I eat anything I can _______\n"
            'I live in a hole in an old _______\n'
            'I am a wolf, a cousin to dogs\n'
            "But I'm _______ than dogs\n"
            'I howl to talk with my _______',
      ),
      LessonSection(
        title: 'Answers',
        body:
            'time, upside, moon, mask, find, tree, stronger, friends',
      ),
      LessonSection(
        title: 'Your opinion',
        body:
            'Which animal is the most interesting? Why?\n'
            'If you were one of these animals, which would you be?',
      ),
      LessonSection(
        title: 'Vocabulary',
        body:
            'owl - сова\n'
            'raccoon - енот\n'
            'wolf - волк\n'
            'forest - лес\n'
            'night - ночь\n'
            'fly - летать\n'
            'run - бегать\n'
            'hunt - охотиться\n'
            'strong - сильный\n'
            'cute - милый',
      ),
    ],
    questions: [
      QuizQuestion(
        prompt: 'What is the lesson song about?',
        options: [
          'Farm animals in the morning',
          'Night animals and their behavior',
          'Pets in a house',
          'A zoo trip',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Which animal can turn its face upside down in the song?',
        options: ['Wolf', 'Raccoon', 'Owl', 'Elephant'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What does the owl do at night?',
        options: [
          'Sleeps in water',
          'Hunts and looks around',
          'Hides in a box',
          'Eats grass',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What kind of animal is the raccoon in the lyrics?',
        options: [
          'It has a mask',
          'It has wings',
          'It lives in the ocean',
          'It is a farm bird',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What does the raccoon eat?',
        options: [
          'Only meat',
          'Only grass',
          'Anything it can find',
          'Only fish',
        ],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'Where does the raccoon live in the song?',
        options: [
          'In an old tree',
          'In a cave by the sea',
          'In a classroom',
          'In a nest',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'The wolf is a cousin to which animal?',
        options: ['Cats', 'Dogs', 'Bears', 'Foxes'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'How does the wolf talk with friends?',
        options: ['By dancing', 'By whispering', 'By howling', 'By singing'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What word completes: "It\'s our _______"?',
        options: ['night', 'time', 'forest', 'home'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Which three animals appear in this listening lesson?',
        options: [
          'Owl, raccoon, wolf',
          'Horse, duck, sheep',
          'Lion, tiger, bear',
          'Dog, cat, rabbit',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  LessonContent(
    id: 'writing_dream_pet',
    title: 'Writing',
    subtitle: 'My Dream Pet',
    type: LessonType.text,
    accentColor: 0xFFFF8C42,
    contentTitle: 'Write an email to your mom',
    contentBody:
        'Students plan a short email about a dream pet. The task focuses on '
        'simple sentence building, structure, and basic personal reasons.',
    sections: [
      LessonSection(
        title: 'Step 1. Think',
        body:
            'Answer the questions:\n'
            'What animal do you want as a pet?\n'
            'Why do you want it?\n'
            'Where will it live? (home / room / garden)\n'
            'What will you feed it?',
      ),
      LessonSection(
        title: 'Step 2. Write',
        body:
            'Use this structure:\n'
            'Dear Mom,\n'
            'My dream pet is ...\n'
            'I want it because ...\n'
            'It will live in ...\n'
            'I will feed it ...\n'
            'I will take care of it.\n'
            'Bye,\n'
            'Your son/daughter ...',
      ),
      LessonSection(
        title: 'Step 3. Check',
        body:
            'I used "Dear Mom" and "Bye".\n'
            'I wrote 5-6 sentences.\n'
            'I used capital letters.\n'
            'I checked spelling.',
      ),
      LessonSection(
        title: 'Task format',
        body:
            'This section can later include a photo prompt (.jpg) and a writing '
            'area for the student response.',
      ),
    ],
    questions: [
      QuizQuestion(
        prompt: 'Who should the student write the email to?',
        options: ['Teacher', 'Friend', 'Mom', 'Doctor'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What is the topic of the email?',
        options: [
          'My school bag',
          'My dream pet',
          'My favorite food',
          'My holiday',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Which greeting is used in the structure?',
        options: ['Hello teacher', 'Dear Mom', 'Good afternoon', 'Hi class'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What should the student explain after naming the pet?',
        options: [
          'Why they want it',
          'How old the mom is',
          'What time school starts',
          'Where the zoo is',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'Which place is suggested for the pet to live?',
        options: [
          'Home, room, or garden',
          'Airport only',
          'Mountain only',
          'River only',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What should the student include about food?',
        options: [
          'What they will feed it',
          'What the mom will cook',
          'What the teacher likes',
          'What the class eats',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'Which sentence belongs in the email structure?',
        options: [
          'I will take care of it.',
          'I am late for school.',
          'The zoo is very big.',
          'My brother plays football.',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'How many sentences should the student write?',
        options: ['1-2', '3-4', '5-6', '10-12'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What should be checked at the end?',
        options: [
          'Spelling and capital letters',
          'Bus tickets',
          'Animal photos only',
          'Math homework',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'Which closing is suggested?',
        options: ['See you at lunch', 'Bye', 'Best movie ever', 'Good night class'],
        correctIndex: 1,
      ),
    ],
  ),
  LessonContent(
    id: 'reading_baby_elephants',
    title: 'Reading',
    subtitle: 'Two Baby Elephants',
    type: LessonType.text,
    accentColor: 0xFF46C071,
    contentTitle: 'Read the text and answer the questions',
    contentBody:
        'This reading lesson starts with a picture discussion and prediction, '
        'then moves to a short text about two baby elephants born in a zoo in '
        'the United Kingdom.',
    sections: [
      LessonSection(
        title: 'Before reading',
        body:
            'Look at the picture and answer:\n'
            'What animals can you see?\n'
            'Where do they live? (forest, zoo, farm, ocean)\n'
            'What are they doing?\n\n'
            'Think and guess:\n'
            'What do you think the text is about?\n'
            'Is it about wild animals or pets?\n'
            'What information will you read? (food, habitat, behavior)',
      ),
      LessonSection(
        title: 'Text',
        body:
            'Two baby elephants have been born at a zoo in the United Kingdom. '
            'The first baby was born last week, and the second arrived two days '
            'later. Zoo workers say both elephants are healthy and active. '
            'Visitors are excited to see the babies. There is a special area '
            'where people can watch the elephants safely. The zoo hopes the '
            'births will help the elephant population and teach people about '
            'wildlife.',
      ),
      LessonSection(
        title: 'After reading',
        body:
            'Choose the correct answer and complete the sentences.\n'
            '1. How many baby elephants were born?\n'
            '2. Where were they born?\n'
            '3. When was the first baby elephant born?\n\n'
            'Complete:\n'
            'The babies are healthy and active.\n'
            'People can watch the elephants in a special area.\n'
            'The zoo wants to help the elephant population.',
      ),
      LessonSection(
        title: 'Vocabulary',
        body:
            'zoo - зоопарк\n'
            'elephant - слон\n'
            'healthy - здоровый\n'
            'active - активный\n'
            'wildlife - дикая природа\n'
            'population - популяция',
      ),
    ],
    questions: [
      QuizQuestion(
        prompt: 'How many baby elephants were born?',
        options: ['1', '2', '3', '4'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Where were the baby elephants born?',
        options: ['In Africa', 'In a UK zoo', 'On a farm', 'In a forest'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'When was the first baby elephant born?',
        options: ['Last week', 'Last month', 'Yesterday', 'Two years ago'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'When did the second baby arrive?',
        options: ['The same day', 'Two days later', 'One month later', 'At night'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'How do zoo workers describe the babies?',
        options: [
          'Healthy and active',
          'Scared and quiet',
          'Weak and sleepy',
          'Old and tired',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'How do visitors feel?',
        options: ['Excited', 'Angry', 'Bored', 'Confused'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'Where can people watch the elephants?',
        options: [
          'In a special safe area',
          'Inside the cage',
          'From a school bus',
          'From the forest',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What does the zoo hope these births will help?',
        options: [
          'The elephant population',
          'The weather',
          'The city traffic',
          'The school library',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What else does the zoo want to teach people about?',
        options: ['Cooking', 'Wildlife', 'Painting', 'Computers'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What is the text mainly about?',
        options: [
          'A dangerous animal attack',
          'A zoo trip to the ocean',
          'Two baby elephants born in a zoo',
          'How to buy a pet elephant',
        ],
        correctIndex: 2,
      ),
    ],
  ),
];
