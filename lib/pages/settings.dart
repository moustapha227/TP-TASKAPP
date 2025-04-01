import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/theme/theme_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        margin: EdgeInsets.only(left: 25, right: 20, top: 10),

        decoration: BoxDecoration(
          //color: const Color.fromARGB(255, 249, 250, 250),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dark Mode",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged:
                  (value) =>
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
