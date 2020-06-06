import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex/model/pokedex.dart';


class PokedexService{

  static String url = 'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';
  Pokedex pokedex;


  Future<Pokedex> fetchPokemon() async{

    var response = await http.get(url);
    var decodedJson = json.decode(response.body);
    pokedex = Pokedex.fromJson(decodedJson);
    return pokedex;

  }

}