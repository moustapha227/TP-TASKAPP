class Task {
  int id;
  String title; // titre
  String description; // description
  String dueDate; //date d'echeance
  String priority; //faible, moyenne, élevée
  String status; //à faire, en cours, terminé
  bool isnotification = true;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dueDate: json['dueDate'],
    priority: json['priority'],
    status: json['status'],
  );

  Map<String, dynamic> tojson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate,
    'priority': priority,
    'status': status,
  };
}
