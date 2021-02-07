import 'package:baby_sleep_scheduler/views/help/expandable_info.dart';
import 'package:flutter/material.dart';

class QandA extends StatefulWidget {
  QandA(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QandAState();
  }
}

class _QandAState extends State<QandA> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandableInfo(
          label: 'How to use the Ferber sleep trainer app?',
          main:
              '1. Read this FAQ section (especially the "before you start" section)\n\n'
              '2. Review the editor section and make your selection of the timing you want for your baby\n\n'
              '3. Before starting the training, make sure the baby is sleepy\n\n'
              '4. Once the baby is placed in bed, start with the "Trainer"\n\n'
              '5. Once you have placed the baby in bed and left the room, start the timer by selecting "Placed baby in bed"\n\n'
              '6. If you have a baby cam - you will be able to monitor if the baby is awake or asleep. Select the option accordingly. '
              'If you do not have a baby cam, every time you do not hear the baby - assume that the baby is asleep\n\n'
              '7. As time progresses, and the baby is crying, the app will guide you on how long to wait before subsequent check-ins. '
              'It is hard to hear your baby cry, but remember, this is only for a short while and will benefit the baby in the long run\n\n'
              '8. When the trainer shows - "Check on baby", go in the room, comfort the baby by talking in a soothing voice, or gently patting them. '
              'Don\'t pick up the baby or feed them. Stay a maximum of two minutes and once outside tap - "Checked on baby"\n\n'
              '9. If the baby is getting quieter when the timer ends, you may choose to give them a few more mins to see if they sleep off. '
              'When you enter the room it is not unusual for the baby to cry louder than they have been just before you entered. Soothe them the best way you can\n\n'
              '10. In the morning once the baby wakes up, you can tap the done sleeping to record the sleeping time in statistics. '
              'If not tapped, the app automatically assumes that the baby had slept for 12 hours and advances the day',
          further:
              'In case of an unsuccessful training session, please ensure that you use the timer for the previous day, as if the training had not happened on the previous day\n\n'
              'For your benefit, the app also has a section on Activity that records the statistics of your sleep training sessions. You will notice that '
              'as time passes your baby’s crying time will reduce as the baby starts learning to self soothe. Time to sleep will also reduce significantly. '
              'Once you find that the time to sleep has reduced to less than 5 mins, you can say that ferberization is complete. You may continue to use the app to record the statistics.',
        ),
        ExpandableInfo(
          label: 'What is the Ferber Method and its benefits?',
          main:
              'The Ferber method also known as "graduated extinction" was developed by pediatric sleep expert Dr. Richard Ferber. '
              'It teaches babies to self-soothe, so they can fall asleep on their own and fall back to sleep when they wake up during the night.',
          further:
              'Though emotionally challenging for parents, the process is very simple and brings with it a host of benefits for both the babies and parents. '
              'Once the baby has identified how to self-soothe and put themselves back to sleep - they sleep for longer, deeper, and are more rested when they wake up in the morning. '
              'For parents, they do not have to wake up multiple times in the middle of the night to rock or sing the baby back to sleep - '
              'self-soothing teaches them how to go back to sleep on their own if they wake up in the middle of sleep.\n\n'
              'The Ferber method may be very hard for some parents, and strong resolve is needed to gain the benefits. '
              'Trust in yourself and trust in your instincts will go a long way. If you are successful with the method, both you and your baby will sleep better.',
        ),
        ExpandableInfo(
          label: 'What are check-ins?',
          main: 'The process:\n\n'
              '1. Start with the bedtime routine (see “before you start” section)\n'
              '2. Once you feel the baby is drowsy but awake put the baby in bed (look for signs of yawning, rubbing eyes, drowsy eyes)\n'
              '3. You may read the story at this point, if not already done so\n'
              '4. Tell your baby goodnight. Tell them you love them and will see them in the morning and leave the room\n'
              '5. If the baby cries, wait for the designated amount of time before you go back into the room\n'
              '6. Comfort the baby by talking in a soothing voice, or gently patting them. Don\'t pick up the baby or feed them\n'
              '7. Leave the room after a minute or so, or if the baby stops crying. Repeat as needed, ensuring that you have waited for the designated time'
              '\n\nDuring the check-ins, you’ll go to your baby at timed intervals that gradually get longer until they fall asleep. '
              'The check-ins also get longer on subsequent nights. Dr. Ferber calls it the "progressive waiting approach."',
        ),
        ExpandableInfo(
          label: 'Who is the Ferber method right for?',
          main:
              'Babies are generally ready for sleep training, around 5 or 6 months. At that point, they’re developmentally capable of self-soothing. '
              'They’re also old enough to sleep through the night without eating. You don’t have to sleep train as soon as your baby hits the 5- or 6-month mark. '
              'If you’d feel more comfortable holding off until your little one is a bit older, that’s okay. Just keep in mind that the older your baby gets, '
              'the harder it might be for her to learn to fall asleep on her own instead of being rocked, fed, or soothed by you.',
          further:
              'Please make sure you have consulted with your baby\'s doctor before starting the Ferber method. This method should not be used with any '
              'babies with underlying health conditions or any types of sleep or other disorders. Always remember that you are the best judge of your baby\'s '
              'well-being. The Ferber method, the app, and the proposed times are only guides and you are in the driving seat.  Always pay attention to the baby\'s '
              'cries, if something does not feel right, act on your intuition, and the process can be continued later',
        ),
        ExpandableInfo(
          label: 'What is self-soothing?',
          main:
              'Soothing is defined as babies getting a feeling of happiness and calm. This can be attained with a mother\'s touch, a father\'s voice, music from '
              'a toy, rocking, rubbing, or walking with baby in hand. Self-soothing is letting the baby identify ways where he/she could get the same feeling but '
              'on his / her own. This could be playing with their own fingers, scratching the bedsheet, muffling a blanket, or hugging a toy (remember Joey\'s hugsie?).',
          further:
              'Self-soothing is crucial not just to get to sleep, but also to stay asleep. We all sleep in cycles of 90 mins. Even as adults we wake up after '
              'each 90-minute cycle; either turning over or taking a deep sigh and eventually going back to sleep. However, babies are creatures of habit and '
              'haven’t learned to go back to sleep like this yet. Instead, if they are in the habit of being rocked to sleep; they want to be rocked back to '
              'sleep every 90-minutes. Hence, when managing to sleep on their own by self-soothing they can put themselves back to sleep again.',
        ),
        ExpandableInfo(
          label: 'Things to keep in mind before you start',
          main:
              'Humans are creatures of habit. More so babies. Initiate a bedtime routine a few days before starting the Ferber method, so that the baby recognizes '
              'the queues to sleep time. Whilst there’s no set rule, try to identify what works for your family? Some go for a bath time routine, while others go '
              'out for walks; however, reading a storybook remains the gold-standard (same one every night!)',
          further:
              'Self-soothing is the key to the Ferber method. Keep an assortment of props for the baby to choose from (insert a hyperlink to self-soothing question). '
              'For example, a soft blanket, a bedsheet, a toy that is travel-friendly. The most favored is a blanket, easy to carry and for night outs with family. '
              'So make sure there are a few props for the baby to choose from. See above, examples include soft blanket, a bedsheet, which you can keep for years, a '
              'hugsy toy, which you can carry when you travel etc. The best is to use the blanket as it is easy to carry in your travels or even if you are doing a '
              'night out with a family.\n\n'
              'Post the bedtime routine, make sure you start the training only when the baby is drowsy but awake. Make sure the baby is in a safe environment, '
              'and you can hear the baby crying from outside the room. If you have a baby monitor, make sure you are able to see the baby. But a baby monitor is not '
              'essential for the sleep training\n\n'
              'Every baby is different and special in its way. A majority taking 3-7 days learning self-soothe, some taking even longer. The crying and time taken to '
              'sleep will reduce noticeably faster as the days pass. One thankful parent told us that their baby cried for a total of 25 mins on the first day, '
              'followed by 16 mins the next day, 6 mins the next day, and was asleep in 3 mins on the fourth day.',
        ),
        ExpandableInfo(
          label: 'Support',
          main:
              'For questions related to your baby\'s health, please consult with your doctor.\n\n'
              'For questions about how to use the app, feel free to email at ferber.sleep.trainer@gmail.com. We strive to respond in 48 - 72 hours of your query',
        ),
      ],
    );
  }
}
