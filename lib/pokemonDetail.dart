import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokedex/model/pokedex.dart';

class PokemonDetail extends StatefulWidget {
  Pokemon pokemon;

  PokemonDetail({this.pokemon});

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  PaletteGenerator paletteGenerator;
  Color dominantColor;

  @override
  void initState() {
    super.initState();
    findDominantColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dominantColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.pokemon.name),
      ),
      body: getBodyStack(context),
    );
  }

  Stack getBodyStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        getBGPositioned(context),
        getMainImage(),
      ],
    );
  }

  Align getMainImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: Hero(
        tag: widget.pokemon.img,
        child: Container(
          height: 150,
          width: 150,
          child: Image.network(
            widget.pokemon.img,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Positioned getBGPositioned(BuildContext context) {
    return Positioned(
      height: MediaQuery.of(context).size.height * (2 / 3),
      width: MediaQuery.of(context).size.width - 20,
      left: 10,
      top: MediaQuery.of(context).size.height * 0.1,
      child: getInfoCard(),
    );
  }

  Card getInfoCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: getFeaturesColumm(),
    );
  }

  Column getFeaturesColumm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          height: 65,
        ),
        Text(
          widget.pokemon.name,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          "Height: " + widget.pokemon.height,
        ),
        Text(
          "Weight: " + widget.pokemon.weight,
        ),
        Text(
          "Types",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        getTypeNameRow(),
        Text(
          "Next Evolation",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        getNextEvolutionRow(),
        Text(
          "Weaknesses",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        getWeaknessesRow()
      ],
    );
  }

  Row getWeaknessesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.pokemon.weaknesses
          .map(
            (weaknesses) => Chip(
              label: Text(
                weaknesses,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              backgroundColor: Colors.deepOrange.shade300,
            ),
          )
          .toList(),
    );
  }

  Row getNextEvolutionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.pokemon.nextEvolution != null
          ? widget.pokemon.nextEvolution
              .map(
                (evolution) => Chip(
                  label: Text(
                    evolution.name,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  backgroundColor: Colors.deepOrange.shade300,
                ),
              )
              .toList()
          : [
              Chip(
                label: Text(
                  "Evolution Of The Last Stage",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                backgroundColor: Colors.deepOrange.shade300,
              ),
            ],
    );
  }

  Row getTypeNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.pokemon.type
          .map(
            (typeName) => Chip(
              label: Text(
                typeName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              backgroundColor: Colors.deepOrange.shade300,
            ),
          )
          .toList(),
    );
  }

  void findDominantColor() {
    Future<PaletteGenerator> fPaletteGenerator =
        PaletteGenerator.fromImageProvider(NetworkImage(widget.pokemon.img));

    fPaletteGenerator.then((value) {
      paletteGenerator = value;

      setState(() {
        dominantColor = paletteGenerator.vibrantColor.color;
      });
    });
  }
}
