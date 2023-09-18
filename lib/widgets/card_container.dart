import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardContainer extends StatefulWidget {
  final String? title;
  final String? desc;
  final Color colorBox;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  CardContainer({
    Key? key,
    this.title,
    this.desc,
    required this.colorBox,
    this.onView,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _CardContainerState createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: widget.colorBox,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.desc!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: widget.onView!,
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              GestureDetector(
                onTap: widget.onEdit!,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              GestureDetector(
                onTap: widget.onDelete!,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
