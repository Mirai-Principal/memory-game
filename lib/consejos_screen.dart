import 'package:flutter/material.dart';

class ConsejoData {
  final int number;
  final String imagePath;
  final Color numberColor;
  final String text;

  const ConsejoData({
    required this.number,
    required this.imagePath,
    required this.numberColor,
    required this.text,
  });
}

class ConsejosScreen extends StatelessWidget {
  const ConsejosScreen({super.key});

  static const List<ConsejoData> consejos = [
    ConsejoData(
      number: 1,
      imagePath: 'assets/images/img_cards/1.png',
      numberColor: Color(0xFF43A047), // Verde
      text:
          'Usa el dosificador indicado, evita cucharas de cocina y respeta la dosis prescrita por tu médico.',
    ),
    ConsejoData(
      number: 2,
      imagePath: 'assets/images/img_cards/2.png',
      numberColor: Color(0xFFF4511E), // Naranja
      text: 'Tapa los depósitos de agua y límpialos cada semana.',
    ),
    ConsejoData(
      number: 3,
      imagePath: 'assets/images/img_cards/3.png',
      numberColor: Color(0xFF00897B), // Turquesa / verde azulado
      text:
          'Protégete de las picaduras, también durante el día. Usa mosquiteros y repelente.',
    ),
    ConsejoData(
      number: 4,
      imagePath: 'assets/images/img_cards/4.png',
      numberColor: Color(0xFFE91E63), // Rosa rojizo
      text: 'Controla la temperatura y sigue las indicaciones de tu médico.',
    ),
    ConsejoData(
      number: 5,
      imagePath: 'assets/images/img_cards/5.png',
      numberColor: Color(0xFF00ACC1), // Celeste intenso
      text:
          'Ante dolor abdominal intenso, vómitos persistentes o sangrado, busca atención inmediata, aunque la fiebre haya bajado.',
    ),
    ConsejoData(
      number: 6,
      imagePath: 'assets/images/img_cards/6.png',
      numberColor: Color(0xFFEC407A), // Rosa claro
      text:
          'FRIZAC ayuda a aliviar la fiebre y el dolor. Úsalo según la indicación médica.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.white, Color.fromARGB(255, 188, 229, 255)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context, topPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ...consejos.map((item) => ConsejoItemCard(data: item)),
                    const SizedBox(height: 20),
                    _buildVolverAlJuegoButton(context),
                    SizedBox(height: bottomPadding + 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Column(
      children: [
        // Pestaña CONSEJOS extendida hasta el borde superior
        Container(
          padding: EdgeInsets.only(
            top: topPadding > 0 ? topPadding + 3 : 4,
            bottom: 4,
            left: 52,
            right: 52,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEA6497),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEA6497).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'CONSEJOS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 26,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // ¡SIGUE APRENDIENDO CON
        const Text(
          '¡SIGUE\nAPRENDIENDO CON',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF003B73),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            height: 1.15,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 0),
        // FRIZAC!®
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLetter('F', const Color(0xFF4CAF50)),
            _buildLetter('R', const Color(0xFFFF7043)),
            _buildLetter('I', const Color(0xFF00BCD4)),
            _buildLetter('Z', const Color(0xFFFFB300)),
            _buildLetter('A', const Color(0xFFEC407A)),
            _buildLetter('C', const Color(0xFF29B6F6)),
            _buildLetter('!', const Color(0xFF003B73)),
            const Padding(
              padding: EdgeInsets.only(top: 4.0, left: 2.0),
              child: Text(
                '®',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B73),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 0),
        // Pequeñas acciones, grandes resultados...
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Pequeñas acciones, grandes\nresultados en la salud de tu familia.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0288D1),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLetter(String char, Color color) {
    return Text(
      char,
      style: TextStyle(
        color: color,
        fontSize: 42,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
        shadows: [
          Shadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildVolverAlJuegoButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF97CA6), // Rosa claro superior
            Color(0xFFE23887), // Rosa magenta inferior
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE23887).withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 46, vertical: 5),
            child: Text(
              'Volver al juego',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Componente reutilizable para cada tarjeta de consejo
class ConsejoItemCard extends StatelessWidget {
  final ConsejoData data;

  const ConsejoItemCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF70C5F8).withValues(alpha: 0.38),
            blurRadius: 16,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contenedor de la imagen que ocupa toda la altura de la card
            Container(
              width: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFD0F0FD),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 14),
            // Círculo con el número
            Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: data.numberColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${data.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Texto descriptivo del consejo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 14.0,
                  bottom: 14.0,
                  right: 18.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.text,
                    style: const TextStyle(
                      color: Color(0xFF004DA6),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
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
}
