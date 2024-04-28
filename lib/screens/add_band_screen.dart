import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/rock_band.dart';
import '../services/database_service.dart';

class AddBandScreen extends StatefulWidget {
  @override
  _AddBandScreenState createState() => _AddBandScreenState();
}

class _AddBandScreenState extends State {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  File? _albumImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _albumImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _addBand() async {
    if (_nameController.text.isNotEmpty &&
        _albumController.text.isNotEmpty &&
        _releaseYearController.text.isNotEmpty) {
      final RockBand band = RockBand(
        name: _nameController.text,
        album: _albumController.text,
        releaseYear: int.parse(_releaseYearController.text),
        votes: 0,
      );
      if (_albumImage != null) {
        final String imageUrl =
            await _databaseService.uploadAlbumImage(_albumImage!);
        band.albumImageUrl = imageUrl;
      }
      _databaseService.addBand(band);
      _nameController.clear();
      _albumController.clear();
      _releaseYearController.clear();
      setState(() {
        _albumImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Banda'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _albumController,
                decoration: InputDecoration(labelText: 'Álbum'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _releaseYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Año de lanzamiento'),
              ),
              SizedBox(height: 20),
              _albumImage != null
                  ? Image.file(
                      _albumImage!,
                      height: 100,
                    )
                  : GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(Icons.add_photo_alternate),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBand,
                child: Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
