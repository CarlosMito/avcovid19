class Schedule {
  late final String userCPF;
  late final int? id;
  late String cep;
  late int day;
  late int month;
  late int year;
  late int st;

  int get hour => st ~/ 60;
  int get minute => st % 60;

  String get date =>
      year.toString().padLeft(2, '0') +
      '/' +
      month.toString().padLeft(2, '0') +
      '/$day';

  String get time {
    var h = hour.toString().padLeft(2, '0');
    var m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // ST stands for Schedule Time (minutos após 00:00)
  // SD stands for Schedule Date (no formato DD/MM/AAAA)

  Schedule.fromJson(Map json) {
    var pieces = json['sd'].split('/');

    cep = json['cep'];
    id = json['_id'];
    userCPF = json['user_cpf'];
    st = json['st'];
    year = int.parse(pieces[0]);
    month = int.parse(pieces[1]);
    day = int.parse(pieces[2]);
  }

  Map<String, dynamic> toJson() => {
        'user_cpf': userCPF,
        'cep': cep,
        'st': st,
        'date': date,
      };
}
