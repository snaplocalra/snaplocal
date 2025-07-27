abstract class ComplimentActionState {
  void initialAction();
  void removeBadge();
  void selectAlreadyAssignedBadge();
  void selectNewBadge();
}

abstract class AbstractComplimentActionState implements ComplimentActionState {
  final ComplimentActionController controller;

  AbstractComplimentActionState(this.controller);

  @override
  void initialAction() {}

  @override
  void removeBadge() {}

  @override
  void selectAlreadyAssignedBadge() {}

  @override
  void selectNewBadge() {}
}

class ComplimentActionController {
  late ComplimentActionState state;

  ComplimentActionController() {
    state = InitialComplimentActionState(this);
  }

  void setState(ComplimentActionState state) {
    this.state = state;
  }

  void initialAction() => state.initialAction();
  void removeBadge() => state.removeBadge();
  void selectAlreadyAssignedBadge() => state.selectAlreadyAssignedBadge();
  void selectNewBadge() => state.selectNewBadge();
}

class InitialComplimentActionState extends AbstractComplimentActionState {
  InitialComplimentActionState(super.controller);

  @override
  void removeBadge() {
    controller.setState(RemoveComplimentBadgeState(controller));
  }

  @override
  void selectAlreadyAssignedBadge() {
    controller.setState(SelectAlreadyAssignedBadgeState(controller));
  }

  @override
  void selectNewBadge() {
    controller.setState(SelectNewComplimentBadgeState(controller));
  }
}

class RemoveComplimentBadgeState extends AbstractComplimentActionState {
  RemoveComplimentBadgeState(super.controller);

  @override
  void initialAction() {
    controller.setState(InitialComplimentActionState(controller));
  }

  @override
  void selectAlreadyAssignedBadge() {
    controller.setState(SelectAlreadyAssignedBadgeState(controller));
  }

  @override
  void selectNewBadge() {
    controller.setState(SelectNewComplimentBadgeState(controller));
  }
}

class SelectAlreadyAssignedBadgeState extends AbstractComplimentActionState {
  SelectAlreadyAssignedBadgeState(super.controller);

  @override
  void initialAction() {
    controller.setState(InitialComplimentActionState(controller));
  }

  @override
  void removeBadge() {
    controller.setState(RemoveComplimentBadgeState(controller));
  }

  @override
  void selectNewBadge() {
    controller.setState(SelectNewComplimentBadgeState(controller));
  }
}

class SelectNewComplimentBadgeState extends AbstractComplimentActionState {
  SelectNewComplimentBadgeState(super.controller);

  @override
  void initialAction() {
    controller.setState(InitialComplimentActionState(controller));
  }

  @override
  void removeBadge() {
    controller.setState(RemoveComplimentBadgeState(controller));
  }

  @override
  void selectAlreadyAssignedBadge() {
    controller.setState(SelectAlreadyAssignedBadgeState(controller));
  }
}
