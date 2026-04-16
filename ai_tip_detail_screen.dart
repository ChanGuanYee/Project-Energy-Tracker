import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiTipDetailScreen extends StatefulWidget {
  final String shortTip;
  const AiTipDetailScreen({super.key, required this.shortTip});

  @override
  State<AiTipDetailScreen> createState() => _AiTipDetailScreenState();
}

class _AiTipDetailScreenState extends State<AiTipDetailScreen> {
  String _aiResponse = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateAiTips();
  }

  Future<void> _generateAiTips() async {
    const apiKey = 'YOUR API KEY'; 

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
    The user is looking at this energy-saving tip: "${widget.shortTip}". 
    Please act as an energy-saving expert. Generate a detailed, practical guide in English with 3-4 actionable steps on how to implement this specific tip to save electricity at home. Use clear formatting.
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _aiResponse = response.text ?? 'No response generated.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _aiResponse = 'Failed to connect to AI. Please check your network and API Key.\nError: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Energy Expert',style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Tip:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              widget.shortTip,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Divider(height: 30, thickness: 2),
            
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 15),
                          Text('Gemini 2.5 is generating tips...'),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Text(
                        _aiResponse,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}