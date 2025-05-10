import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final bool fullPage;
  
  const LoadingSpinner({
    Key? key,
    this.fullPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fullPage) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
