import 'package:flutter/material.dart';
import 'package:pokedex/services/pokedexService.dart';
import 'model/pokedex.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final pokedexService = PokedexService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
      ),
      body: bodyFutureBuilder(),
    );
  }

  FutureBuilder<Pokedex> bodyFutureBuilder() {
    return FutureBuilder(
      future: pokedexService.fetchPokemon(),
      builder: (context, AsyncSnapshot<Pokedex> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return gridViewBuilder(snapshot);
        }
      },
    );
  }

  GridView gridViewBuilder(AsyncSnapshot<Pokedex> snapshot) {
    return GridView.builder( 
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Text(snapshot.data.pokemon[index].name);
      },
    );
  }
}
