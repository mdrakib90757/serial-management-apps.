import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerList extends StatelessWidget {
  final int itemCount;
  final Widget? leading;
  const CustomShimmerList({super.key, this.itemCount = 6, this.leading});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          // child:
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(5),
          //     border: Border.all(color: Colors.grey.shade200),
          //   ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 22,
              ),
              title: Container(
                height: 14,
                width: double.infinity,
                color: Colors.grey.shade200,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 120,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 180,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 100,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ),
        );
        //);
      },
    );
  }
}
