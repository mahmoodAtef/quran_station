class Question {
  final String questionText;
  final List<String> answers;
  final int trueAnswerIndex;
  final int id;
  int? userAnswer;
  Question(
      {required this.questionText,
      required this.id,
      required this.answers,
      required this.trueAnswerIndex});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        questionText: json["question_text"],
        answers: List<String>.from(json["answers"]),
        trueAnswerIndex: json["true_answer_index"],
        id: json["question_id"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "question_id": id,
      "question_text": questionText,
      "answers": answers,
      "true_answer_index": trueAnswerIndex
    };
    return data;
  }

  void setAnswer(int answerIndex) {
    userAnswer = answerIndex;
  }

  int getMark() {
    return userAnswer == trueAnswerIndex ? 1 : 0;
  }
}

List<Question> myQuestions = [
  Question(
      id: 1,
      questionText: "كم عدد سجدات التلاوة في القران الكريم؟",
      answers: ["7 سجدات", "4 سجدات", "15 سجدة"],
      trueAnswerIndex: 2),
  Question(
      id: 2,
      questionText: "كم عدد سجدات التلاوة في السور المكية؟",
      answers: ["سجدتين", "3 سجدات", "12 سجدة"],
      trueAnswerIndex: 2),
  Question(
      id: 3,
      questionText: "كم عدد سجدات التلاوة في السور المدنية؟",
      answers: ["سجدة واحدة", "4 سجدات", "3 سجدات"],
      trueAnswerIndex: 2),
  Question(
      id: 4,
      questionText: "كم عدد السور المسماه باسماء أنبياء؟",
      answers: ["7 سور", "4 سور", "6 سور"],
      trueAnswerIndex: 2),
  Question(
      id: 5,
      questionText: "كم عدد السور المسماه باسماء مواقيت الصلاة؟",
      answers: ["5 سور", "4 سور", "3 سور"],
      trueAnswerIndex: 2),
  Question(
      id: 6,
      questionText: "ماهي أول السور المدنية نزولا في القرآن؟",
      answers: ["الحديد", "آل عمران", "البقرة"],
      trueAnswerIndex: 2),
  Question(
      id: 7,
      questionText: "ماهي آخر السور المكية نزولا في القرآن؟",
      answers: ["الجمعة", "القلم", "المطففين"],
      trueAnswerIndex: 2),
  Question(
      id: 8,
      questionText: "آخر آية نزلت من القرآن؟",
      answers: [
        "كُلُّ شَيْءٍ هَالِكٌ إِلَّا وَجْهَهُ ۚ لَهُ الْحُكْمُ وَإِلَيْهِ تُرْجَعُونَ",
        "اليومَ أكْمَلْتُ لَكُمْ دِينَكُمْ وأَتْمَمْتُ علَيْكُم نِعْمَتي ورَضِيتُ لَكُمُ الإسْلامَ دِينًا",
        "وَاتَّقُوا يَوْمًا تُرْجَعُونَ فِيهِ إِلَى اللَّهِ ثُمَّ تُوَفَّى كُلُّ نَفْسٍ مَا كَسَبَتْ وَهُمْ لا يُظْلَمُونَ"
      ],
      trueAnswerIndex: 2),
  Question(
      id: 9,
      questionText: "أكبر السور المكية من حيث عدد الآيات",
      answers: ["الذاريات", "البقرة", "الشعراء"],
      trueAnswerIndex: 2),
  Question(
      id: 10,
      questionText: "من هي المرأة الوحيدة التي ذكرت في القرآن باسمها؟",
      answers: ["السيدة آسيا امرأة فرعون", "السيدة خديجة", "السيدة مريم"],
      trueAnswerIndex: 2),
  Question(
      id: 11,
      questionText: "عشر سور مدنيات متتاليات في المصحف",
      answers: ["الواقعة:الطلاق", "الحديد:التحريم", "المجادلة:الملك"],
      trueAnswerIndex: 1),
  Question(
      id: 12,
      questionText: "اكبر ربع في القرآن من حيث عدد الآيات",
      answers: ["الربع الأخير من جزء تبارك", "الربع الأول من جزء عم", "الربع الأخير من جزء عم"],
      trueAnswerIndex: 1),
  Question(
      id: 13,
      questionText: "أكبر عدد ذكر في القرآن الكريم",
      answers: ["200 ألف", "100 ألف", "ألف"],
      trueAnswerIndex: 1),
  Question(
      id: 14,
      questionText: "أصغر عدد ذكر في القرآن الكريم",
      answers: ["1", "⅒ (عُشر)", "نصف"],
      trueAnswerIndex: 1),
  Question(
      id: 15,
      questionText: "سورة بدأت باسم ثمرتين",
      answers: ["آل عمران", "التين", "الأنعام"],
      trueAnswerIndex: 1),
  Question(
      id: 16,
      questionText: "سورة بدأت بسورة",
      answers: ["المائدة", "النور", "النساء"],
      trueAnswerIndex: 1),
  Question(
      id: 17,
      questionText: "أحد أركان الاسلام مسمى باسمه سورة",
      answers: ["الصوم", "الحج", "الصلاة"],
      trueAnswerIndex: 1),
  Question(
      id: 18,
      questionText: "سورة وردت بها البسملة مرتين",
      answers: ["لقمان", "النمل", "السجدة"],
      trueAnswerIndex: 1),
  Question(
      id: 19,
      questionText: "سورة لا تبدأ بالبسملة",
      answers: ["النساء", "التوبة", "الأنعام"],
      trueAnswerIndex: 1),
  Question(
      id: 20,
      questionText: "سورة تنتهي باسم نبيين",
      answers: ["الصافات", "الأعلى", "ابراهيم"],
      trueAnswerIndex: 1),
  Question(
      id: 21,
      questionText: "سورة تبدأ باسم من أسماء الله الحسنى",
      answers: ["الرحمن", "الطور", "الحجر"],
      trueAnswerIndex: 0),
  Question(
      id: 22,
      questionText: "سورة تسمى باسم غزوة من غزوات النبي ﷺ",
      answers: ["الأحزاب", "الاسراء", "الروم"],
      trueAnswerIndex: 0),
  Question(
      id: 23,
      questionText: "سورة أوصى النبي ﷺ بتعليمها للنساء",
      answers: ["النور", "النساء", "لقمان"],
      trueAnswerIndex: 0),
  Question(
      id: 24,
      questionText: "سورة لا تخلو آية من آياتها من لفظ الجلالة الله",
      answers: ["المجادلة", "المدثر", "الرحمن"],
      trueAnswerIndex: 0),
  Question(
      id: 25,
      questionText: "سورة ثلاثون آية تنجي صاحبها من عذاب القبر",
      answers: ["الملك", "الحشر", "الصف"],
      trueAnswerIndex: 0),
  Question(
      id: 26,
      questionText: "سورة تبدأ بالتسبيح و تنتهي بالتسبيح",
      answers: ["الحشر", "الصف", "الكهف"],
      trueAnswerIndex: 0),
  Question(
      id: 27,
      questionText: "سورة نهايتها أمر للمؤمنين بالاستغفار",
      answers: ["المزمل", "نوح", "ص"],
      trueAnswerIndex: 0),
  Question(
      id: 28,
      questionText: 'سورة قال عنها النبي ﷺ "لا تستطيعها البطلة" أي السحرة',
      answers: ["البقرة", "الفلق", "الناس"],
      trueAnswerIndex: 0),
  Question(
      id: 29,
      questionText: "آخر سور القرآن نزولا",
      answers: ["النصر", "الفتح", "القلم"],
      trueAnswerIndex: 0),
  Question(
      id: 30,
      questionText: "يوم ذكر في القرآن أكثر من مرة",
      answers: ["السبت", "الجمعة", "الخميس"],
      trueAnswerIndex: 0),
];
