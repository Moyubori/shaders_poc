import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class BlurHashWidget extends StatefulWidget {
  final bool useShader;
  const BlurHashWidget({
    super.key,
    required this.useShader,
  });

  @override
  _BlurHashWidgetState createState() => _BlurHashWidgetState();
}

class _BlurHashWidgetState extends State<BlurHashWidget> {
  final List<String> hashes = [
    "L5H2EC=PM+yV0g-mq.wG9c010J}I",
    "LEHLh[WB2yk8pyoJadR*.7kCMdnj",
    "LGF5?xYk^6#M@-5c,1J5@[or[Q6.",
    "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
    "LKN]Rv%2Tw=w]~RBVZRi};RPxuwH",
    "LPPa1u%M-qjd-aR*I:bb0BRkNEbG",
    "LRLm\$y5vVxjF~0wyNMV{Oa\$wxCR:",
    "|EHLh[WB2yk8\$NxujFNGt6pyoJadR*=ss:I[R%of.7kCMdnjx]S2NHs:i_S#M|%1%2ENRis9a\$%1Sis.slNHW:WBxZ%2NbogaekBW;ofo0NHS4j?W?WBsloLR+oJofS2s:ozj@s:jaR*Wps.j[RkT0of%2afR*fkoJjZof",
    "|HF5?xYk^6#M9wKSW@j=#*@-5b,1J5O[V=R:s;w[@[or[k6.O[TLtJnNnO};FxngOZE3NgNHsps,jMFxS#OtcXnzRjxZxHj]OYNeR:JCs9xunhwIbeIpNaxHNGr;v}aeo0Xmt6XS\$et6#*\$ft6nhxHnNV@w{nOenwfNHo0",
    "|6PZfSi_.AyE8^m+%gt,o~_3t7t7R*WBs,ofR-a#*0o#DgR4.Tt,ITVYZ~_3R*D%xt%MIpRj%0oJMcV@%itSI9R5x]tRbcIot7-:IoM{%LoeIVjuNHoft7M{RkxuozM{ae%1WBg4tRV@M{kCxuog?vWB9Et7-=NGM{xaae",
    "|KN]Rv%2Tw=wR6cErDEhOD]~RBVZRip0W9ofwxM_};RPxuwH%3s89]t8\$%tLOtxZ%gixtQt8IUS#I.ENa0NZIVt6xFM{M{%1j^M_bcRPX9nht7n+j[rrW;ni%Mt7V@W;t7t8%1bbxat7WBIUR*RjRjRjxuRjs.MxbbV@WY",
  ];

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (_, index) {
            return AspectRatio(
              aspectRatio: 1.6,
              child: BlurHash(
                hash: hashes[(index + Random().nextInt(5)) % hashes.length],
                decodingHeight: 64,
                decodingWidth: 64,
              ),
            );
          },
        ),
      );
}
