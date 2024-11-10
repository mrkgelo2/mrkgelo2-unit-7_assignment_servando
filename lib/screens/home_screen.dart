import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>> fetchCharacters() async {
    const url = 'https://api.disneyapi.dev/character';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 59, 255),
        title: const Text(
          "Unit 7 - API Calls",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final characters = snapshot.data!;

            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                final tileController = ExpandedTileController();

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ExpandedTile(
                    controller: tileController,
                    title: Text(
                      character['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    content: Column(
                      children: [
                        if (character['imageUrl'] != null)
                          Image.network(
                            character['imageUrl'],
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 10),
                        Text(
                          character['films'] != null &&
                                  character['films'].isNotEmpty
                              ? 'Films: ${character['films'].join(', ')}'
                              : 'No film information available',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    theme: const ExpandedTileThemeData(
                      contentBackgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
