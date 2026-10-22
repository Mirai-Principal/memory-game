import 'package:flutter/material.dart';

/// Widget de alerta/mensaje que replica el diseño con borde redondeado ámbar,
/// título vibrante, imagen central intercambiable y texto descriptivo.
class Mensaje extends StatelessWidget {
  /// Título principal (por ejemplo: "¡Reto completado!")
  final String title;

  /// Estilo de texto personalizado para el título
  final TextStyle? titleStyle;

  /// Texto descriptivo o mensaje secundario
  final String? description;

  /// Estilo de texto personalizado para la descripción
  final TextStyle? descriptionStyle;

  /// Ruta del asset de la imagen (por ejemplo: 'assets/images/...')
  final String? imageAsset;

  /// Widget personalizado para la imagen (si se provee, tiene prioridad sobre [imageAsset])
  final Widget? imageWidget;

  /// Altura asignada a la imagen central
  final double imageHeight;

  /// Ancho asignado a la imagen central
  final double? imageWidth;

  /// Modo de ajuste de la imagen
  final BoxFit imageFit;

  /// Color del borde exterior
  final Color borderColor;

  /// Ancho del borde exterior
  final double borderWidth;

  /// Radio de curvatura de las esquinas
  final double borderRadius;

  /// Color de fondo del diálogo/tarjeta
  final Color backgroundColor;

  /// Padding interno
  final EdgeInsetsGeometry padding;

  /// Margen exterior opcional
  final EdgeInsetsGeometry? margin;

  /// Ancho máximo de la tarjeta/alerta
  final double maxWidth;

  /// Texto del botón de acción (por defecto "Salir")
  final String? buttonText;

  /// Callback al presionar el botón de acción (por defecto cierra con Navigator.pop)
  final VoidCallback? onButtonPressed;

  /// Botones o acciones opcionales al pie del mensaje (si se proveen, tienen prioridad sobre [buttonText])
  final List<Widget>? actions;

  /// Espaciado vertical entre cada sección
  final double spacing;

  const Mensaje({
    super.key,
    this.title = '¡Reto completado!',
    this.titleStyle,
    this.description =
        'Encontraste las 6 figuras, comparte\nlo aprendido con tu familia.',
    this.descriptionStyle,
    this.imageAsset,
    this.imageWidget,
    this.imageHeight = 160.0,
    this.imageWidth,
    this.imageFit = BoxFit.contain,
    this.borderColor = const Color(0xFFFCC04C), // Ámbar/amarillo cálido
    this.borderWidth = 4.0,
    this.borderRadius = 28.0,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26.0),
    this.margin,
    this.maxWidth = 420.0,
    this.buttonText = 'Salir',
    this.onButtonPressed,
    this.actions,
    this.spacing = 16.0,
  });

  /// Muestra el mensaje como un diálogo/alerta modal en pantalla
  static Future<T?> show<T>({
    required BuildContext context,
    String title = '¡Reto completado!',
    TextStyle? titleStyle,
    String? description =
        'Encontraste las 6 figuras, comparte\nlo aprendido con tu familia.',
    TextStyle? descriptionStyle,
    String? imageAsset,
    Widget? imageWidget,
    double imageHeight = 160.0,
    double? imageWidth,
    BoxFit imageFit = BoxFit.contain,
    Color borderColor = const Color(0xFFFCC04C),
    double borderWidth = 4.0,
    double borderRadius = 28.0,
    Color backgroundColor = Colors.white,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 26.0,
    ),
    String? buttonText = 'Salir',
    VoidCallback? onButtonPressed,
    List<Widget>? actions,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          child: Mensaje(
            title: title,
            titleStyle: titleStyle,
            description: description,
            descriptionStyle: descriptionStyle,
            imageAsset: imageAsset,
            imageWidget: imageWidget,
            imageHeight: imageHeight,
            imageWidth: imageWidth,
            imageFit: imageFit,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            padding: padding,
            buttonText: buttonText,
            onButtonPressed: onButtonPressed,
            actions: actions,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = const TextStyle(
      color: Color(0xFFEE3E75), // Rosa / magenta vibrante
      fontSize: 26.0,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.3,
    ).merge(titleStyle);

    final effectiveDescStyle = const TextStyle(
      color: Color(0xFF27BCEE), // Celeste / cyan vibrante
      fontSize: 16.0,
      fontWeight: FontWeight.w800,
      height: 1.35,
    ).merge(descriptionStyle);

    Widget? renderedImage;
    if (imageWidget != null) {
      renderedImage = imageWidget;
    } else if (imageAsset != null && imageAsset!.isNotEmpty) {
      renderedImage = Image.asset(
        imageAsset!,
        height: imageHeight,
        width: imageWidth,
        fit: imageFit,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: imageHeight,
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          );
        },
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Título
              if (title.isNotEmpty)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: effectiveTitleStyle,
                ),

              // 2. Imagen central
              if (renderedImage != null) ...[
                SizedBox(height: spacing),
                renderedImage,
              ],

              // 3. Descripción
              if (description != null && description!.isNotEmpty) ...[
                SizedBox(height: spacing),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: effectiveDescStyle,
                ),
              ],

              // 4. Botón de acción o acciones personalizadas
              if (actions != null && actions!.isNotEmpty) ...[
                SizedBox(height: spacing + 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: actions!,
                ),
              ] else if (buttonText != null && buttonText!.isNotEmpty) ...[
                SizedBox(height: spacing + 6),
                _buildStyledButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(BuildContext context) {
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
          onTap: onButtonPressed ?? () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 12),
            child: Text(
              buttonText!,
              style: const TextStyle(
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
