import 'package:flutter/material.dart';
import 'package:your_app/models/rock_band.dart';
import 'package:your_app/services/database_service.dart';

class BandListScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RockBand>>(
      stream: _databaseService.getRockBands(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<RockBand> bands = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Lista de Bandas de Rock'),
          ),
          body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(bands[index].name),
                subtitle: Text(
                    'Álbum: ${bands[index].albumName}, Año: ${bands[index].releaseYear}'),
                trailing: Text('${bands[index].votes} votos'),
                onTap: () {
                  _databaseService.voteRockBand(bands[index].id);
                },
              );
            },
          ),
        );
      },
    );
  }
}
