import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About this App')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Infoshots version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Data Source: This app uses the MediaWiki API to fetch content from Wikipedia. We believe in the mission of free knowledge and encourage users to support the Wikimedia Foundation.',
            ),
            SizedBox(height: 16),
            Text(
              'Legal Disclaimer: This app is not an official product of the Wikimedia Foundation. It is an independent project developed to help users discover new information. All Wikipedia logos and trademarks are the property of the Wikimedia Foundation.',
            ),
            SizedBox(height: 16),
            Text(
              'Licensing: Textual content from Wikipedia is licensed under CC BY-SA 4.0. By using this app, you agree to respect the licensing terms of the original authors.',
            ),
            Spacer(),
            Text('Contact: basicdevlove@gmail.com'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
