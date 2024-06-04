String capitalizeEachWord(String value) {
  return value.split(' ').map((word) {
    return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
  }).join(' ');
}
