import 'package:easy_quiz_game/easy_quiz_game.dart';

final data = [
  QuizCategory(
    name: 'Películas Animadas',
    description: 'Este cuestionario es sobre películas animadas',
    iconImage: 'assets/images/animated movies.jpg',
    difficulty: QuizDifficulty.beginner,
    quizzes: [
      Quiz(
          question:
          '¿Qué utiliza el personaje principal de Up para hacer flotar su casa?',
          options: ['Imanes', 'Jets', 'Magia', 'Globos'],
          correctIndex: 3,
          hint: 'Creo que son los imanes o los globos',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium),
      Quiz(
          question: '¿Qué película animada trata sobre insectos?',
          options: ['Kung Fu Panda', 'El Gigante de Hierro', 'Hormiguitaz', 'Gatos y Perros'],
          correctIndex: 2,
          hint: 'Creo que es Hormiguitaz o Gatos y Perros',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium),
      Quiz(
          question:
          '¿Qué película animada presenta a un elefante como personaje principal?',
          options: ['Shrek', 'La Sirenita', 'Kung Fu Panda', 'Dumbo'],
          correctIndex: 3,
          hint: 'Creo que es Dumbo o La Sirenita',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium),
      Quiz(
          question:
          'Jack Black da voz a un panda en cuál de las siguientes películas animadas?',
          options: ['El Viaje de Chihiro', 'Coco', 'Kung Fu Panda', 'Frozen'],
          correctIndex: 2,
          hint: 'Creo que es Kung Fu Panda o Frozen',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium),
    ],
  ),
  QuizCategory(
    name: 'Comida',
    description: 'Este cuestionario es para obtener información sobre alimentos',
    iconImage: 'assets/images/food.png',
    difficulty: QuizDifficulty.easy,
    quizzes: [
      Quiz(
          question: '¿Qué alimento se considera un snack saludable?',
          options: ['Helado de agua', 'Galletas', 'Manzana', 'Patatas Fritas'],
          correctIndex: 2,
          hint: 'Creo que es Manzana o Patatas Fritas',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: '¿Cuál es la sustancia dulce hecha por las abejas?',
          options: ['Miel', 'Zumo de Naranja', 'Vainilla', 'Tapioca'],
          correctIndex: 0,
          hint: 'Creo que es Tapioca o Miel',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: '¿Qué fruta se usa comúnmente para hacer vino?',
          options: ['Cereza', 'Pera', 'Uva', 'Ciruela'],
          correctIndex: 2,
          hint: 'Creo que es Cereza o Uva',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: '¿Qué aparato se usa para cocinar?',
          options: ['Microondas', 'Lavavajillas', 'Lavadora', 'Plancha'],
          correctIndex: 0,
          hint: 'Creo que es Microondas o Lavavajillas',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: '¿Cuál de estos es un alimento básico para el desayuno?',
          options: ['Helado', 'Judías verdes', 'Espaguetis', 'Huevos'],
          correctIndex: 3,
          hint: 'Creo que son Espaguetis o Huevos',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.easy),
    ],
  ),
  QuizCategory(
    name: 'Romance',
    description: 'Este cuestionario es para obtener información sobre el amor',
    iconImage: 'assets/images/Love.png',
    difficulty: QuizDifficulty.easy,
    quizzes: [
      Quiz(
          question: 'assets/images/love 1.jpg',
          options: [
            'Iron Man',
            'Spider Man',
            'Batman Inicia',
            'Capitana Marvel'
          ],
          correctIndex: 1,
          hint: 'Creo que es Spider Man o Batman Inicia',
          questionType: QuizQuestionType.image,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: 'assets/images/love 2.jpg',
          options: [
            'El Cantante de Bodas',
            'Happy Gilmore',
            'Billy Maddison',
            'Un Papá Genial'
          ],
          correctIndex: 0,
          hint: 'Creo que es El Cantante de Bodas o Un Papá Genial',
          questionType: QuizQuestionType.image,
          difficulty: QuizDifficulty.easy),
      Quiz(
          question: '¿Qué película animada trata sobre insectos?',
          options: ['Kung Fu Panda', 'El Gigante de Hierro', 'Hormiguitaz', 'Gatos y Perros'],
          correctIndex: 2,
          hint: 'Creo que es Hormiguitaz o Gatos y Perros',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium),
    ],
  ),
  QuizCategory(
    name: 'Animales',
    description: 'Este cuestionario es para obtener información sobre animales',
    iconImage: 'assets/images/animals.png',
    difficulty: QuizDifficulty.easy,
    quizzes: [
      Quiz(
          question: 'assets/images/bear.jpg',
          options: ['Hienas', 'Oso Grizzly', 'Oso Polar', 'Pandas Gigantes'],
          correctIndex: 1,
          hint: 'Definitivamente no son Hienas',
          questionType: QuizQuestionType.image,
          difficulty: QuizDifficulty.hard),
      Quiz(
          question: '¿Qué animal espinoso tiene púas en su cuerpo?',
          options: [
            'Mantarraya',
            'Tiburón Martillo',
            'Avispa Amarilla',
            'Puercoespín'
          ],
          correctIndex: 3,
          hint: 'Creo que es Mantarraya o Puercoespín',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.hard),
      Quiz(
          question:
          '¿Cuál de estos es un animal grande que permanece mucho tiempo en el agua?',
          options: ['Sapo', 'Hipopótamo', 'Águila Calva', 'Ruiseñor'],
          correctIndex: 1,
          hint: 'Creo que es Hipopótamo o Ruiseñor',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.hard),
      Quiz(
          question: '¿Cuál es el mamífero más grande del mundo?',
          options: ['León Marino', 'Ballena Azul', 'Rinoceronte', 'Oso'],
          correctIndex: 1,
          hint: 'Creo que es Rinoceronte o Ballena Azul',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.hard),
    ],
  ),
];
