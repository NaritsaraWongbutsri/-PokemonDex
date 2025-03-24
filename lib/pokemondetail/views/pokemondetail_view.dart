import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({Key? key, required this.pokemonListItem})
      : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? _pokemonDetailData; // ข้อมูลโปเกมอน
  bool _isLoading = true; // โหลดอยู่?
  String? _error; // ข้อผิดพลาด

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // โหลดข้อมูล
  Future<void> loadData() async {
    setState(() {
      _isLoading = true; // เริ่มโหลด
      _error = null; // ล้าง error
    });
    try {
      final response = await http.get(
          Uri.parse(widget.pokemonListItem.url)); // ดึงข้อมูลจาก URL โปเกมอน
      if (response.statusCode == 200) {
        final detailData = jsonDecode(response.body);
        setState(() {
          _pokemonDetailData = detailData; // เก็บข้อมูล
          _isLoading = false; // โหลดเสร็จ
        });
      } else {
        setState(() {
          _error = 'Failed to load Pokemon details'; // Error โหลดข้อมูลล้มเหลว
          _isLoading = false; // โหลดเสร็จ (error)
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}'; // Error จาก Exception
        _isLoading = false; // โหลดเสร็จ (error)
      });
    }
  }

  // Widget ประเภทโปเกมอน
  List<Widget> _buildTypeWidgets(List<dynamic> types) {
    return types.map((type) {
      final typeName = type['type']['name'];
      Color typeColor;

      // กำหนดสีประเภท
      switch (typeName) {
        case 'normal':
          typeColor = Colors.grey;
          break;
        case 'fire':
          typeColor = Colors.orange;
          break;
        case 'water':
          typeColor = Colors.blue;
          break;
        case 'grass':
          typeColor = Colors.green;
          break;
        case 'electric':
          typeColor = Colors.yellow;
          break;
        case 'ice':
          typeColor = Colors.cyan;
          break;
        case 'fighting':
          typeColor = Colors.red;
          break;
        case 'poison':
          typeColor = Colors.purple;
          break;
        case 'ground':
          typeColor = Colors.brown;
          break;
        case 'flying':
          typeColor = Colors.indigo;
          break;
        case 'psychic':
          typeColor = Colors.pink;
          break;
        case 'bug':
          typeColor = Colors.lightGreen;
          break;
        case 'rock':
          typeColor = Colors.amber;
          break;
        case 'ghost':
          typeColor = Colors.deepPurple;
          break;
        case 'dragon':
          typeColor = Colors.deepOrange;
          break;
        case 'steel':
          typeColor = Colors.blueGrey;
          break;
        case 'fairy':
          typeColor = Colors.pinkAccent;
          break;
        default:
          typeColor = Colors.grey.shade400;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: typeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          typeName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  // Widget สถิติโปเกมอน
  List<Widget> _buildStatWidgets(List<dynamic> stats) {
    return stats.map((stat) {
      final statName = stat['stat']['name'];
      final baseStat = stat['base_stat'];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                statName.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: LinearProgressIndicator(
                value: baseStat / 200, // ค่าสถิติ / maxValue
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(width: 8),
            Text(baseStat.toString()),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading Indicator
          : _error != null
              ? Center(child: Text('Error: $_error')) // แสดง Error
              : _pokemonDetailData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // รูปโปเกมอน
                          Image.network(
                            _pokemonDetailData!['sprites']['front_default'] ??
                                'URL_รูปภาพสำรอง', // รูป default ด้านหน้า
                            width: 200,
                            height: 200,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 200,
                                color: Colors.grey,
                              ); // Icon error หากโหลดรูปไม่สำเร็จ
                            },
                          ),
                          const SizedBox(height: 20),

                          // ชื่อโปเกมอน
                          Text(
                            widget.pokemonListItem.name.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // ประเภท
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                _buildTypeWidgets(_pokemonDetailData!['types']),
                          ),
                          const SizedBox(height: 20),

                          // สถานะเริ่มต้น
                          const Text(
                            'สถานะเริ่มต้น',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children:
                                _buildStatWidgets(_pokemonDetailData!['stats']),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('No Pokemon data')), // ไม่มีข้อมูลโปเกมอน
    );
  }
}
