String getAchievementEmoji(String category) {
  switch (category.toLowerCase()) {
    case 'steps':
      return '👣';
    case 'streaks':
      return '🔥';
    case 'trails':
      return '⛰️';
    case 'social':
      return '🤝';
    case 'events':
      return '🎊';
    default:
      return '🏅';
  }
}

String getMotivationalMessage(String category) {
  switch (category.toLowerCase()) {
    case 'steps':
      return 'Every step counts! Keep moving!';
    case 'streaks':
      return 'Keep your streak alive!';
    case 'trails':
      return 'Adventure awaits on the trail!';
    case 'social':
      return 'Invite friends for more fun!';
    case 'events':
      return 'Special event, special you!';
    default:
      return 'You are closer than you think!';
  }
}
