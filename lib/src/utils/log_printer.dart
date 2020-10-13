import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var color = PrettyPrinter.levelColors[level];
    var emoji = PrettyPrinter.levelEmojis[level];
    var white = PrettyPrinter.levelColors[Level.warning];
    println(white('#########################################################'));
    println(color('$emoji  [$className]  ${DateTime.now()} '));
    println(color(' $message'));
    println(white('#########################################################'));
  }
}
