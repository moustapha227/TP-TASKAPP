class Task {
  int id;
  String title; // titre
  String description; // description
  DateTime dueDate; //date d'echeance
  String priority; //faible, moyenne, élevée
  String status; //à faire, en cours, terminé

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  // Convertir un objet Task en Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'status': status,
    };
  }
}
