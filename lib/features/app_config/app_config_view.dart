import 'package:flutter/material.dart';
import './app_config_view_model.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class AppConfigView extends AppConfigViewModel {
  @override
  Widget build(BuildContext context) {
    final languages = [
      {'label': 'Português', 'locale': const Locale('pt', 'BR')},
      {'label': 'English', 'locale': const Locale('en', 'US')},
      {'label': 'Español', 'locale': const Locale('es', 'ES')},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.strings.settingsTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              I18n.strings.languageLabel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButton<Locale>(
              value: selectedLocale,
              items: languages.map((lang) {
                return DropdownMenuItem<Locale>(
                  value: lang['locale'] as Locale,
                  child: Text(lang['label'] as String),
                );
              }).toList(),
              onChanged: (locale) {
                if (locale != null) changeLanguage(locale);
              },
            ),

            const SizedBox(height: 32),

            Text(
              'Áudio',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(
                  isAudioPlaying ? Icons.volume_up : Icons.volume_off,
                  color: isAudioPlaying ? Colors.green : Colors.grey,
                ),
                title: Text(
                  isAudioPlaying
                      ? 'Áudio de Fundo Ativo'
                      : 'Áudio de Fundo Desativado',
                ),
                subtitle: Text(
                  isAudioPlaying
                      ? 'Música tocando em loop'
                      : 'Clique para ativar a música',
                ),
                trailing: Switch(
                  value: isAudioPlaying,
                  onChanged: (value) {
                    toggleBackgroundAudio();
                  },
                ),
                onTap: () {
                  toggleBackgroundAudio();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
