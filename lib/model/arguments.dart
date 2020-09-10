class TaskDetail {
  TaskDetail({this.type, this.page});

  final String type;
  final int page;
}

class TaskDetailMember {
  TaskDetailMember({this.type, this.page, this.phase, this.number});

  final String type;
  final int page;
  final String phase;
  final int number;
}

class Community {
  Community({this.type, this.taskid, this.effortid});

  final String type;
  final String taskid;
  final String effortid;
}