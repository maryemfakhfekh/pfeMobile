// lib/features/encadrant/data/models/evaluation_model.dart

class EvaluationModel {
	final int                 id;
	final int                 stagiaireId;
	final String              nomComplet;
	final String              periode;
	final Map<String, double> criteres;
	final double              note;       // moyenne /5
	final double              noteFinale; // /20
	final String              commentaire;
	final String              date;

	const EvaluationModel({
		required this.id,
		required this.stagiaireId,
		required this.nomComplet,
		required this.periode,
		required this.criteres,
		required this.note,
		required this.noteFinale,
		required this.commentaire,
		required this.date,
	});

	String get appreciation {
		if (note >= 4.5) return 'Excellent';
		if (note >= 4.0) return 'Très bien';
		if (note >= 3.0) return 'Bien';
		if (note >= 2.0) return 'Assez bien';
		if (note >= 1.0) return 'Passable';
		return 'Insuffisant';
	}

	factory EvaluationModel.fromJson(Map<String, dynamic> json) {
		return EvaluationModel(
			id:          json['id'] ?? 0,
			stagiaireId: json['stagiaireId'] ?? 0,
			nomComplet:  json['nomComplet'] ?? '',
			periode:     json['periode'] ?? '',
			criteres:    Map<String, double>.from(json['criteres'] ?? {}),
			note:        (json['note'] ?? 0).toDouble(),
			noteFinale:  (json['noteFinale'] ?? 0).toDouble(),
			commentaire: json['commentaire'] ?? '',
			date:        json['date'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
		'id':          id,
		'stagiaireId': stagiaireId,
		'nomComplet':  nomComplet,
		'periode':     periode,
		'criteres':    criteres,
		'note':        note,
		'noteFinale':  noteFinale,
		'commentaire': commentaire,
		'date':        date,
	};
}