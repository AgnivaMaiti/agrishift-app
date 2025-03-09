import 'package:flutter/material.dart';

class Professional {
  final String name;
  final String role;
  final String imageUrl;

  Professional({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class ProfessionalDirectory extends StatefulWidget {
  const ProfessionalDirectory({super.key});

  @override
  State<ProfessionalDirectory> createState() => _ProfessionalDirectoryState();
}

class _ProfessionalDirectoryState extends State<ProfessionalDirectory> {
  int? selectedIndex;

  final List<Professional> professionals = List.generate(
    6,
    (index) => Professional(
      name: 'Person ${index + 1}',
      role: 'Strategic & Finance',
      imageUrl: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Directory'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: professionals.length,
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              },
              child: ProfessionalCard(
                professional: professionals[index],
                isExpanded: isSelected,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfessionalCard extends StatefulWidget {
  final Professional professional;
  final bool isExpanded;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.isExpanded,
  });

  @override
  State<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends State<ProfessionalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ProfessionalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.isExpanded
            ? const Color.fromARGB(255, 229, 190, 255)
            : Colors.grey.shade100,
        boxShadow: widget.isExpanded
            ? [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: widget.isExpanded ? 6 : 7,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/shivam.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: widget.isExpanded ? 4 : 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Shivam',
                          style: TextStyle(
                            fontSize: widget.isExpanded ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Developer',
                          style: TextStyle(
                            fontSize: widget.isExpanded ? 14 : 12,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.isExpanded)
              Positioned.fill(
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: buildSocialIcons(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: widget.isExpanded ? 16 : 12,
          backgroundColor: Colors.white,
          child: Image(image: AssetImage('assets/images/facebook.png')),
        ),
        SizedBox(width: widget.isExpanded ? 16 : 8),
        CircleAvatar(
          radius: widget.isExpanded ? 16 : 12,
          backgroundColor: Colors.white,
          child: Image(image: AssetImage('assets/images/x.png')),
        ),
        SizedBox(width: widget.isExpanded ? 16 : 8),
        CircleAvatar(
          radius: widget.isExpanded ? 16 : 12,
          backgroundColor: Colors.white,
          child: Image(image: AssetImage('assets/images/linkedin.png')),
        )
      ],
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const SocialIcon({
    super.key,
    required this.icon,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 14,
      ),
    );
  }
}
