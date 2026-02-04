import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/widgets/OvalIcon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Assuming ExpandedText.dart and main_text.dart are in the same widgets directory
import 'ExpandedText.dart';
import 'main_text.dart';

class SessionCard extends StatefulWidget {
  final String image;
  final String sessionTitle;
  final String startTime;
  final String location;
  final String? dayRemaining;
  final DateTime eventDate;
  final bool? isEnded;
  final bool? isLive;
  final VoidCallback? onTap; // Changed to VoidCallback for better type safety

  const SessionCard({
    super.key,
    required this.image,
    required this.sessionTitle,
    required this.startTime,
    required this.location,
    this.onTap,
    this.isEnded,
    required this.eventDate,
    this.dayRemaining = "3 days more", // Default value
    this.isLive = false, // Default value
  });

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    // Start the animation if isLive is initially true
    if (widget.isLive == true) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SessionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Control animation based on isLive property changes
    if (widget.isLive == true && oldWidget.isLive == false) {
      _animationController.forward();
    } else if (widget.isLive == false && oldWidget.isLive == true) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
    DateFormat('EEE, MMM d, y').format(widget.eventDate);
    final DateTime parsedStartTime =
    DateFormat("HH:mm:ss").parse(widget.startTime);
    final String formattedStartTime =
    DateFormat("hh:mm a").format(parsedStartTime);

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
              ),
            ),

            const SizedBox(height: 10),

            /// Title + Start Time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MainText(
                    text: widget.sessionTitle,
                    fontSize: 20,
                    maxLines: 2,

                  ),
                ),
                const SizedBox(width: 10),
                MainText(
                  text: formattedStartTime,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Location
            Row(
              children: [
                const Icon(BootstrapIcons.geo_alt,
                    color: Colors.white, size: 15),
                const SizedBox(width: 10),
                Expanded(
                  child: MainText(
                    text: widget.location,
                    maxLines: 1,

                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Date
            Row(
              children: [
                const Icon(BootstrapIcons.calendar,
                    color: Colors.white, size: 15),
                const SizedBox(width: 10),
                Expanded(
                  child: MainText(
                    text: formattedDate,
                    maxLines: 1,

                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            /// Days remaining + Live indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(text: widget.dayRemaining!),

                if (widget.isLive == true)
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Row(
                          children: const [
                            Icon(
                              BootstrapIcons.broadcast,
                              color: Colors.green,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            MainText(text: "Live", color: Colors.green),
                          ],
                        ),
                      );
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
