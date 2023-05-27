import 'package:chewie/chewie.dart';
import 'package:cubook/model/task.dart';
import 'package:cubook/model/themeInfo.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../taskDetailScout_model.dart';

class TaskDetailScoutAddView extends StatelessWidget {
  TaskDetailScoutAddView(int? _index, String? _type, String _mes) {
    themeColor = theme.getThemeColor(_type);
    index_page = _index;
    type = _type;
    mes = _mes;
  }
  int? index_page;
  String? type;
  late String mes;
  Color? themeColor;
  int? countChewie;
  late Map<String, dynamic> content;
  TaskContents task = TaskContents();
  ThemeInfo theme = ThemeInfo();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailScoutModel>(
        builder: (BuildContext context, TaskDetailScoutModel model, _) {
      content = task.getContent(type, model.page, index_page);
      countChewie = 0;
      return Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: themeColor),
          child: const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Text(
                'サインをもらおう！',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height > 700
                ? MediaQuery.of(context).size.height - 334
                : MediaQuery.of(context).size.height - 228,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                if ((type != 'risu' &&
                        type != 'usagi' &&
                        type != 'sika' &&
                        type != 'kuma' &&
                        type != 'challenge' &&
                        type != 'tukinowa') ||
                    model.group == ' j27DETWHGYEfpyp2Y292' ||
                    model.group == ' z4pkBhhgr0fUMN4evr5z')
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: ExpandText(
                        content['body'],
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white),
                        textAlign: TextAlign.justify,
                      ))
                else
                  Container(),
                if (type == 'usagi' ||
                    type == 'sika' ||
                    type == 'kuma' ||
                    type == 'challenge')
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Text(
                        mes,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                else
                  Container(),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.list_attach[index_page!].length,
                        itemBuilder: (BuildContext context, int index) {
                          final String? attach =
                              model.list_attach[index_page!][index];
                          if (attach == 'image') {
                            return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  child: InkWell(
                                    onLongPress: () {},
                                    child: Card(
                                      color: Colors.green,
                                      child: Column(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  '写真をえらぶ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (model.map_attach[index_page!]
                                                  [index] ==
                                              null)
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 44,
                                                        child: TextButton.icon(
                                                          onPressed: () {
                                                            model
                                                                .onImagePressCamera(
                                                                    index_page!,
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.camera_alt,
                                                          ),
                                                          label: const Text(
                                                            'カメラ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: SizedBox(
                                                            height: 44,
                                                            child:
                                                                TextButton.icon(
                                                              onPressed: () {
                                                                model.onImagePressPick(
                                                                    index_page!,
                                                                    index);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .collections,
                                                              ),
                                                              label: const Text(
                                                                'ギャラリー',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )))
                                                  ],
                                                ))
                                          else
                                            Container(
                                                child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Container(
                                                    child: Card(
                                                      color: Colors.green,
                                                      child: Column(
                                                        children: <Widget>[
                                                          if (model.map_attach[
                                                                  index_page!]
                                                              [index] is XFile)
                                                            Image.memory(model
                                                                        .map_show[
                                                                    index_page!]
                                                                [index])
                                                          else
                                                            Image.network(model
                                                                        .map_show[
                                                                    index_page!]
                                                                [index])
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // IconButton(
                                                //   padding: EdgeInsets.all(0),
                                                //   onPressed: () async {
                                                //     model.onPressDelete(
                                                //         index_page!, index);
                                                //   },
                                                //   icon: Icon(
                                                //     Icons.close,
                                                //     color: Colors.white,
                                                //     size: 21,
                                                //   ),
                                                // )
                                              ],
                                            ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          } else if (attach == 'video') {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                  color: Colors.blue,
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.movie,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '動画をえらぶ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (model.map_attach[index_page!]
                                              [index] ==
                                          null)
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10)),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: TextButton.icon(
                                                      onPressed: () {
                                                        model
                                                            .onVideoPressCamera(
                                                                index_page!,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                        Icons.camera_alt,
                                                        size: 20,
                                                      ),
                                                      label: const Text(
                                                        'カメラ',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 44,
                                                        child: TextButton.icon(
                                                          onPressed: () {
                                                            model
                                                                .onVideoPressPick(
                                                                    index_page!,
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.collections,
                                                            size: 20,
                                                          ),
                                                          label: const Text(
                                                            'ギャラリー',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )))
                                              ],
                                            ))
                                      else
                                        Container(
                                            child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                child: Card(
                                                  child: Column(
                                                    children: <Widget>[
                                                      AspectRatio(
                                                          aspectRatio: model
                                                              .map_show[
                                                                  index_page!]
                                                                  [index]
                                                              .aspectRatio,
                                                          child: Chewie(
                                                            controller: model
                                                                        .map_show[
                                                                    index_page!]
                                                                [index],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            /*IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () async {
                                                    model.onPressDelete(index_page, index);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 21,
                                                  ),
                                                )*/
                                          ],
                                        ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (attach == 'text') {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.orange,
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.view_headline,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '文章をかく',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.none,
                                        enabled: true,
                                        controller: model
                                            .map_attach[index_page!][index],
                                        // 入力数
                                        maxLength: 2000,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                      // IconButton(
                                      //   padding: EdgeInsets.all(0),
                                      //   onPressed: () async {
                                      //     model.onPressDelete(
                                      //         index_page!, index);
                                      //   },
                                      //   icon: Icon(
                                      //     Icons.close,
                                      //     color: Colors.white,
                                      //     size: 21,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                )),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })),
                FilledButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'text');
                  },
                  icon: const Icon(
                    Icons.view_headline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '文章をいれる',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                ),
                FilledButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'image');
                  },
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '写真をいれる',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                ),
                FilledButton.icon(
                  onPressed: () {
                    model.onPressAdd_new(index_page!, 'video');
                  },
                  icon: const Icon(
                    Icons.movie,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '動画をいれる',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),
                if (type == 'risu' ||
                    type == 'usagi' ||
                    type == 'sika' ||
                    type == 'kuma' ||
                    type == 'challenge')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          activeColor: themeColor,
                          checkColor: Colors.white,
                          value: model.checkParent,
                          onChanged: model.onPressedCheckParent,
                        ),
                        GestureDetector(
                            onTap: () =>
                                model.onPressedCheckParent(!model.checkParent!),
                            child: const Text('保護者チェック'))
                      ],
                    ),
                  )
                else
                  Container(),
                if (!model.isLoading[index_page!])
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: FilledButton.icon(
                        onPressed: () {
                          model.onTapSend(index_page);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'リーダーにサインをお願いする',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(themeColor)),
                      ))
                else
                  Container(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color?>(themeColor),
                        ),
                      ),
                    ),
                  ),
              ],
            )))
      ]);
    });
  }
}
