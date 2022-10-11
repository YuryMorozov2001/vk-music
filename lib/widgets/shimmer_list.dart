
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSongList extends StatelessWidget {
  const ShimmerSongList({super.key, required this.showPlaylists});
  final bool showPlaylists;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              showPlaylists
                  ? SizedBox(
                      height: 110 + 16,
                      child: Shimmer.fromColors(
                        baseColor:
                            Theme.of(context).cardColor.withOpacity(0.30),
                        highlightColor: Colors.grey.withOpacity(0.5),
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(width: 16);
                            },
                            shrinkWrap: true,
                            itemCount: 12,
                            padding: const EdgeInsets.only(
                                left: 12, top: 8, right: 12, bottom: 8),
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16)),
                                width: 110,
                                height: 110,
                              );
                            }),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 8, bottom: 8),
                      child: Opacity(
                        opacity: 1 - (0.1 * index),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(12)),
                          width: p1.maxWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: shimmerWidget(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Shimmer shimmerWidget(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor.withOpacity(0.30),
      highlightColor: Colors.grey.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.30),
                borderRadius: BorderRadius.circular(12)),
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 12,
          ),
          SizedBox(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(12)),
                  height: 16,
                  width: 200.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(12)),
                  height: 16,
                  width: 150.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
