class Question {
  final String questionText;
  final List<String> answers;
  final int trueAnswerIndex;
  int? userAnswer;
  Question({required this.questionText, required this.answers, required this.trueAnswerIndex});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        questionText: json["question_text"],
        answers: json["answers"] as List<String>,
        trueAnswerIndex: json["true_answer_index"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "question_text": questionText,
      "answers": answers,
      "true_answer_index": trueAnswerIndex
    };
    return data;
  }
}

List<Question> myQuestions = [
  Question(
      questionText: "كم عدد سجدات التلاوة في القران الكريم؟",
      answers: ["7 سجدات", "4 سجدات", "15 سجدة"],
      trueAnswerIndex: 2),
  Question(
      questionText: "كم عدد سجدات التلاوة في السور المكية؟",
      answers: ["سجدتين", "3 سجدات", "12 سجدة"],
      trueAnswerIndex: 2),
  Question(
      questionText: "كم عدد سجدات التلاوة في السور المدنية؟",
      answers: ["سجدة واحدة", "4 سجدات", "3 سجدات"],
      trueAnswerIndex: 2),
  Question(
      questionText: "كم عدد السور المسماه باسماء أنبياء؟",
      answers: ["7 سور", "4 سور", "6 سور"],
      trueAnswerIndex: 2),
  Question(
      questionText: "كم عدد السور المسماه باسماء مواقيت الصلاة؟",
      answers: ["5 سور", "4 سور", "3 سور"],
      trueAnswerIndex: 2),
  Question(
      questionText: "ماهي أول السور المدنية نزولا في القرآن؟",
      answers: ["الحديد", "آل عمران", "البقرة"],
      trueAnswerIndex: 2),
  Question(
      questionText: "ماهي آخر السور المكية نزولا في القرآن؟",
      answers: ["الجمعة", "القلم", "المطففين"],
      trueAnswerIndex: 2),
  Question(
      questionText: "آخر آية نزلت من القرآن؟",
      answers: [
        "كُلُّ شَيْءٍ هَالِكٌ إِلَّا وَجْهَهُ ۚ لَهُ الْحُكْمُ وَإِلَيْهِ تُرْجَعُونَ",
        "اليومَ أكْمَلْتُ لَكُمْ دِينَكُمْ وأَتْمَمْتُ علَيْكُم نِعْمَتي ورَضِيتُ لَكُمُ الإسْلامَ دِينًا",
        "وَاتَّقُوا يَوْمًا تُرْجَعُونَ فِيهِ إِلَى اللَّهِ ثُمَّ تُوَفَّى كُلُّ نَفْسٍ مَا كَسَبَتْ وَهُمْ لا يُظْلَمُونَ"
      ],
      trueAnswerIndex: 2),
  Question(
      questionText: "أكبر السور المكية من حيث عدد الآيات",
      answers: ["الذاريات", "البقرة", "الشعراء"],
      trueAnswerIndex: 2),
  Question(
      questionText: "من هي المرأة الوحيدة التي ذكرت في القرآن باسمها؟",
      answers: ["السيدة آسيا امرأة فرعون", "السيدة خديجة", "السيدة مريم"],
      trueAnswerIndex: 2),
  Question(
      questionText: "عشر سور مدنيات متتاليات في المصحف",
      answers: ["الواقعة:الطلاق", "الحديد:التحريم", "المجادلة:الملك"],
      trueAnswerIndex: 1),
  Question(
      questionText: "اكبر ربع في القرآن من حيث عدد الآيات",
      answers: ["الربع الأخير من جزء تبارك", "الربع الأول من جزء عم", "الربع الأخير من جزء عم"],
      trueAnswerIndex: 1),
  Question(
      questionText: "أكبر عدد ذكر في القرآن الكريم",
      answers: ["200 ألف", "100 ألف", "ألف"],
      trueAnswerIndex: 1),
  Question(
      questionText: "أصغر عدد ذكر في القرآن الكريم",
      answers: ["1", "⅒ (عُشر)", "نصف"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة بدأت باسم ثمرتين",
      answers: ["آل عمران", "التين", "الأنعام"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة بدأت بسورة", answers: ["المائدة", "النور", "النساء"], trueAnswerIndex: 1),
  Question(
      questionText: "أحد أركان الاسلام مسمى باسمه سورة",
      answers: ["الصوم", "الحج", "الصلاة"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة وردت بها البسملة مرتين",
      answers: ["لقمان", "النمل", "السجدة"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة لا تبدأ بالبسملة",
      answers: ["النساء", "التوبة", "الأنعام"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة تنتهي باسم نبيين",
      answers: ["الصافات", "الأعلى", "ابراهيم"],
      trueAnswerIndex: 1),
  Question(
      questionText: "سورة تبدأ باسم من أسماء الله الحسنى",
      answers: ["الرحمن", "الطور", "الحجر"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة تسمى باسم غزوة من غزوات النبي ﷺ",
      answers: ["الأحزاب", "الاسراء", "الروم"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة أوصى النبي ﷺ بتعليمها للنساء",
      answers: ["النور", "النساء", "لقمان"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة لا تخلو آية من آياتها من لفظ الجلالة الله",
      answers: ["المجادلة", "المدثر", "الرحمن"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة ثلاثون آية تنجي صاحبها من عذاب القبر",
      answers: ["الملك", "الحشر", "الصف"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة تبدأ بالتسبيح و تنتهي بالتسبيح",
      answers: ["الحشر", "الصف", "الكهف"],
      trueAnswerIndex: 0),
  Question(
      questionText: "سورة نهايتها أمر للمؤمنين بالاستغفار",
      answers: ["المزمل", "نوح", "ص"],
      trueAnswerIndex: 0),
  Question(
      questionText: 'سورة قال عنها النبي ﷺ "لا تستطيعها البطلة" أي السحرة',
      answers: ["البقرة", "الفلق", "الناس"],
      trueAnswerIndex: 0),
  Question(
      questionText: "آخر سور القرآن نزولا",
      answers: ["النصر", "الفتح", "القلم"],
      trueAnswerIndex: 0),
  Question(
      questionText: "يوم ذكر في القرآن أكثر من مرة",
      answers: ["السبت", "الجمعة", "الخميس"],
      trueAnswerIndex: 0),
];
