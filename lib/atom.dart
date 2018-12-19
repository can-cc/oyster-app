class Atom {
  final int id;
  final String title;
  final String content;

  Atom({this.id, this.title, this.content});

  factory Atom.fromJson(Map<String, dynamic> json) {
    return Atom(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class Atoms {
  final List<Atom> items;

  Atoms(this.items);

  factory Atoms.fromJson(List<dynamic> atoms) {
    return Atoms(atoms.map((atom) => Atom.fromJson(atom)).toList());
  }
}
