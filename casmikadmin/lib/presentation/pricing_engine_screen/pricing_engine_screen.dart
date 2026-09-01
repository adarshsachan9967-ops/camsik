import 'package:flutter/material.dart';

class PricingEngineScreen extends StatefulWidget {
  const PricingEngineScreen({super.key});

  @override
  State<PricingEngineScreen> createState() => _PricingEngineScreenState();
}

class _PricingEngineScreenState extends State<PricingEngineScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'question': 'What is the physical condition of the device?',
      'category': 'Condition',
      'answers': [
        {'label': 'Like New', 'impact': 0},
        {'label': 'Good', 'impact': -5},
        {'label': 'Fair', 'impact': -15},
        {'label': 'Poor', 'impact': -30},
      ],
    },
    {
      'id': 2,
      'question': 'Is the screen working properly?',
      'category': 'Screen',
      'answers': [
        {'label': 'Perfect, no issues', 'impact': 0},
        {'label': 'Minor scratches', 'impact': -3},
        {'label': 'Cracked but functional', 'impact': -20},
        {'label': 'Not working', 'impact': -40},
      ],
    },
    {
      'id': 3,
      'question': 'What is the battery health?',
      'category': 'Battery',
      'answers': [
        {'label': 'Above 90%', 'impact': 0},
        {'label': '80–90%', 'impact': -5},
        {'label': '70–80%', 'impact': -10},
        {'label': 'Below 70%', 'impact': -20},
      ],
    },
    {
      'id': 4,
      'question': 'Are all buttons and ports working?',
      'category': 'Functionality',
      'answers': [
        {'label': 'All working', 'impact': 0},
        {'label': 'Minor issues', 'impact': -5},
        {'label': 'Some not working', 'impact': -15},
        {'label': 'Major issues', 'impact': -25},
      ],
    },
    {
      'id': 5,
      'question': 'Do you have original accessories?',
      'category': 'Accessories',
      'answers': [
        {'label': 'Box + all accessories', 'impact': 5},
        {'label': 'Box only', 'impact': 2},
        {'label': 'Charger only', 'impact': 0},
        {'label': 'No accessories', 'impact': -3},
      ],
    },
  ];

  void _showAddEditQuestionDialog({Map<String, dynamic>? question}) {
    final questionCtrl = TextEditingController(
      text: question?['question'] ?? '',
    );
    String selectedCategory = question?['category'] ?? 'Condition';
    List<Map<String, dynamic>> answers = question != null
        ? List<Map<String, dynamic>>.from(
            (question['answers'] as List).map(
              (a) => Map<String, dynamic>.from(a),
            ),
          )
        : [
            {'label': '', 'impact': 0},
          ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            question == null ? 'Add Question' : 'Edit Question',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question *',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: questionCtrl,
                    style: TextStyle(color: textColor, fontSize: 13),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Enter question...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF666666)
                            : const Color(0xFF999999),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF00C853)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Category',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        dropdownColor: bgColor,
                        style: TextStyle(color: textColor, fontSize: 13),
                        items:
                            [
                                  'Condition',
                                  'Screen',
                                  'Battery',
                                  'Functionality',
                                  'Accessories',
                                  'Other',
                                ]
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setS(() => selectedCategory = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Answer Options',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            setS(() => answers.add({'label': '', 'impact': 0})),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853).withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 14,
                                color: Color(0xFF00C853),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xFF00C853),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...answers.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final answer = entry.value;
                    final labelCtrl = TextEditingController(
                      text: answer['label'],
                    );
                    final impactCtrl = TextEditingController(
                      text: answer['impact'].toString(),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: labelCtrl,
                              onChanged: (v) => answers[idx]['label'] = v,
                              style: TextStyle(color: textColor, fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'Answer label',
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF666666)
                                      : const Color(0xFF999999),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF00C853),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: impactCtrl,
                              onChanged: (v) =>
                                  answers[idx]['impact'] = int.tryParse(v) ?? 0,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                  ),
                              style: TextStyle(color: textColor, fontSize: 12),
                              decoration: InputDecoration(
                                hintText: '±%',
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? const Color(0xFF666666)
                                      : const Color(0xFF999999),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF00C853),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              if (answers.length > 1) {
                                setS(() => answers.removeAt(idx));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3B30).withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 14,
                                color: Color(0xFFFF3B30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF888888)
                      : const Color(0xFF666666),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (questionCtrl.text.isNotEmpty) {
                  setState(() {
                    if (question == null) {
                      _questions.add({
                        'id': _questions.length + 1,
                        'question': questionCtrl.text,
                        'category': selectedCategory,
                        'answers': answers,
                      });
                    } else {
                      final idx = _questions.indexOf(question);
                      _questions[idx] = {
                        ...question,
                        'question': questionCtrl.text,
                        'category': selectedCategory,
                        'answers': answers,
                      };
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                question == null ? 'Add Question' : 'Save Changes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF141414) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111111) : Colors.white,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pricing Engine',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_questions.length} questions configured',
                        style: TextStyle(color: subColor, fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showAddEditQuestionDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.black, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Add Question',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final q = _questions[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C853).withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                      color: Color(0xFF00C853),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      q['question'],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF2A2A2A)
                                            : const Color(0xFFF0F0F0),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        q['category'],
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _showAddEditQuestionDialog(question: q),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: subColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _questions.remove(q)),
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: Color(0xFFFF3B30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: borderColor),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: (q['answers'] as List).map<Widget>((
                              answer,
                            ) {
                              final impact = answer['impact'] as int;
                              final isPositive = impact > 0;
                              final isNeutral = impact == 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: subColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        answer['label'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isNeutral
                                            ? (isDark
                                                  ? const Color(0xFF2A2A2A)
                                                  : const Color(0xFFF0F0F0))
                                            : isPositive
                                            ? const Color(
                                                0xFF00C853,
                                              ).withAlpha(30)
                                            : const Color(
                                                0xFFFF3B30,
                                              ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isNeutral
                                            ? '0%'
                                            : '${isPositive ? '+' : ''}$impact%',
                                        style: TextStyle(
                                          color: isNeutral
                                              ? subColor
                                              : isPositive
                                              ? const Color(0xFF00C853)
                                              : const Color(0xFFFF3B30),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}