import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_gallery/bloc/upload_bloc.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _cardButton(context, "Quickcontent hochladen", "Lekker lachen",
                Icon(Icons.face), Image.asset(Constants.image_reaction_emoji),
                onTap: () => {
                      BlocProvider.of<UploadBloc>(context)
                          .add(UploadQuickContentEvent())
                    }),
            _cardButton(
              context,
              "Video hochladen",
              "Lekker lachen",
              Icon(Icons.face),
              Image.asset(Constants.image_reaction_emoji),
            ),
            _cardButton(
              context,
              "Content verwalten",
              "Lekker lachen",
              Icon(Icons.face),
              Image.asset(Constants.image_reaction_emoji),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardButton(BuildContext context, String title, String subtitle,
      Icon icon, Image mainImage,
      {Function()? onTap}) {
    var enabled = onTap != null;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        width: 450,
        height: 300,
        child: Card(
            color: enabled ? Colors.white : Colors.grey,
            elevation: 8,
            child: Column(
              children: [
                ListTile(
                  leading: icon,
                  title: Text(title),
                  subtitle: Text(subtitle),
                ),
                Expanded(
                    child: Center(
                  child: mainImage,
                ))
              ],
            )),
      ),
    );
  }
}
