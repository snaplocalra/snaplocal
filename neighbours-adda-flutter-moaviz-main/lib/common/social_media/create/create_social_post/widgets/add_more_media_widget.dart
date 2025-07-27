import 'package:flutter/material.dart';

class AddMoreMediaWidget extends StatelessWidget {
  final void Function()? onTap;
  const AddMoreMediaWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        width: 80,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(249, 249, 249, 1),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
