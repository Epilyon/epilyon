/*
 * Epilyon, keeping EPITA students organized
 * Copyright (C) 2019-2020 Adrien 'Litarvan' Navratil
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
class MCQ
{
  DateTime date;
  double? average;
  List<MCQGrade>? grades;

  MCQ(this.date, this.average, this.grades);
}

class MCQGrade
{
  String? subject;
  double? grade;

  MCQGrade(this.subject, this.grade);
}

class NextMCQ
{
  bool? skipped;
  DateTime at;
  List<MCQRevision>? revisions;
  String? lastEditor;

  NextMCQ(this.skipped, this.at, this.revisions, this.lastEditor);
}

class MCQRevision
{
  String? subject;
  List<String>? work;

  MCQRevision(this.subject, this.work);
}
