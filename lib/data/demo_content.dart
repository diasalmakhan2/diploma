import '../models/lesson_content.dart';
import '../models/quiz_question.dart';

const lessons = <LessonContent>[
  LessonContent(
    id: 'video_daily_routine',
    title: 'Daily Routine',
    subtitle: 'Видео-урок про повседневные действия',
    type: LessonType.video,
    accentColor: 0xFF46C071,
    contentTitle: 'Morning habits and school day',
    contentBody:
        'Student Emma talks about her morning routine. She wakes up at 7:00, '
        'brushes her teeth, has breakfast with tea and toast, walks to school '
        'with her brother, studies English, math and science, then plays '
        'volleyball after classes.',
    questions: [
      QuizQuestion(
        prompt: 'What time does Emma wake up?',
        options: ['6:00', '7:00', '8:00', '9:00'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What does she do after waking up?',
        options: ['She watches TV', 'She brushes her teeth', 'She sleeps again', 'She runs outside'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What does Emma drink for breakfast?',
        options: ['Coffee', 'Milk', 'Juice', 'Tea'],
        correctIndex: 3,
      ),
      QuizQuestion(
        prompt: 'Who goes to school with Emma?',
        options: ['Her mother', 'Her brother', 'Her friend', 'Her teacher'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'How does Emma get to school?',
        options: ['By bus', 'By taxi', 'On foot', 'By bike'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'Which subject does she study?',
        options: ['History', 'English', 'Art only', 'Music only'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Which sport does Emma play?',
        options: ['Tennis', 'Basketball', 'Volleyball', 'Football'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'When does she play sport?',
        options: ['Before school', 'After classes', 'At night', 'At breakfast'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What meal is mentioned in the lesson?',
        options: ['Dinner', 'Breakfast', 'Lunch', 'Supper'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What is the topic of the video?',
        options: ['Travel plans', 'A school timetable', 'Daily routine', 'Weather report'],
        correctIndex: 2,
      ),
    ],
  ),
  LessonContent(
    id: 'text_my_best_friend',
    title: 'My Best Friend',
    subtitle: 'Текст про дружбу и интересы',
    type: LessonType.text,
    accentColor: 0xFFFFB534,
    contentTitle: 'Reading passage',
    contentBody:
        'Aliya is twelve years old. Her best friend is Dana. They study in the '
        'same class and sit together. Dana is kind, funny and very creative. '
        'She likes drawing and reading adventure books. On weekends, the girls '
        'go to the park, ride bicycles and eat ice cream. Aliya says Dana '
        'always helps her with homework and makes her laugh.',
    questions: [
      QuizQuestion(
        prompt: 'How old is Aliya?',
        options: ['10', '11', '12', '13'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What is the name of her best friend?',
        options: ['Aruzhan', 'Dana', 'Amina', 'Aigerim'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Where do they study?',
        options: ['In different schools', 'In the same class', 'At college', 'At home'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What is Dana like?',
        options: ['Angry and quiet', 'Kind, funny and creative', 'Lazy and rude', 'Strict and serious'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What hobby does Dana have?',
        options: ['Swimming', 'Drawing', 'Cooking', 'Dancing'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What kind of books does Dana read?',
        options: ['Science books', 'Adventure books', 'Cookbooks', 'Poems only'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Where do the girls go on weekends?',
        options: ['To the cinema', 'To the park', 'To the village', 'To the mall'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'What do they ride?',
        options: ['Scooters', 'Horses', 'Bicycles', 'Buses'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What sweet food do they eat?',
        options: ['Cake', 'Chocolate', 'Ice cream', 'Cookies'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'How does Dana help Aliya?',
        options: ['She helps with homework', 'She buys books', 'She cleans the room', 'She cooks dinner'],
        correctIndex: 0,
      ),
    ],
  ),
  LessonContent(
    id: 'video_travel_london',
    title: 'Trip to London',
    subtitle: 'Видео-урок про путешествие и достопримечательности',
    type: LessonType.video,
    accentColor: 0xFF5B7CFA,
    contentTitle: 'City tour',
    contentBody:
        'A short lesson shows a family trip to London. They visit Big Ben, '
        'ride a red bus, take photos near Tower Bridge, eat fish and chips for '
        'lunch, and buy souvenirs in a small shop. The weather is cloudy but '
        'pleasant, so they enjoy walking around the city center.',
    questions: [
      QuizQuestion(
        prompt: 'Which city does the family visit?',
        options: ['Paris', 'Rome', 'London', 'Madrid'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'Which famous place is mentioned first?',
        options: ['Big Ben', 'The museum', 'The airport', 'A castle'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What color is the bus?',
        options: ['Blue', 'Red', 'Green', 'White'],
        correctIndex: 1,
      ),
      QuizQuestion(
        prompt: 'Where do they take photos?',
        options: ['Near Tower Bridge', 'At school', 'In a hotel room', 'At the beach'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What do they eat for lunch?',
        options: ['Pizza', 'Soup', 'Fish and chips', 'Burgers'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'What do they buy in the shop?',
        options: ['Souvenirs', 'Shoes', 'Books', 'Flowers'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What is the weather like?',
        options: ['Snowy', 'Very hot', 'Cloudy but pleasant', 'Stormy'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'How do they feel during the trip?',
        options: ['Bored', 'Scared', 'Happy', 'Angry'],
        correctIndex: 2,
      ),
      QuizQuestion(
        prompt: 'Where do they walk?',
        options: ['In the city center', 'In the forest', 'At the farm', 'At school'],
        correctIndex: 0,
      ),
      QuizQuestion(
        prompt: 'What is the lesson about?',
        options: ['A sports match', 'A trip to London', 'A cooking class', 'A school exam'],
        correctIndex: 1,
      ),
    ],
  ),
];
