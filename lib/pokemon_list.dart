import 'package:flutter/material.dart';
import 'package:pokedex/pokemonDetail.dart';
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
      itemCount: snapshot.data.pokemon.length,
      itemBuilder: (context, index) {
        return pokemonItem(snapshot, index);
      },
    );
  }

  Widget pokemonItem(AsyncSnapshot<Pokedex> snapshot, int index) {
    return InkWell(
      onTap: () {
        pressedPokemonCard(snapshot.data.pokemon[index]);
      },
      child: Hero(
        tag: snapshot.data.pokemon[index].img,
        child: getPokemonCard(snapshot, index),
      ),
    );
  }

  void pressedPokemonCard(Pokemon pokemon) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PokemonDetail(
              pokemon: pokemon,
            )));
  }

  Card getPokemonCard(AsyncSnapshot<Pokedex> snapshot, int index) {
    return Card(
      elevation: 4,
      child: getInfoColumn(snapshot, index),
    );
  }

  Column getInfoColumn(AsyncSnapshot<Pokedex> snapshot, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getPokemonImage(snapshot, index),
        getPokemonName(snapshot, index),
      ],
    );
  }

  Flexible getPokemonImage(AsyncSnapshot<Pokedex> snapshot, int index) {
    return Flexible(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.15,
        child: FadeInImage.assetNetwork(
          placeholder: "assets/loading.gif",
          image: snapshot.data.pokemon[index].img,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Text getPokemonName(AsyncSnapshot<Pokedex> snapshot, int index) {
    return Text(
      snapshot.data.pokemon[index].name,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}
