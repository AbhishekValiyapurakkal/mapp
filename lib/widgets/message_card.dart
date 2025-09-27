import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapp/Api/apis.dart';
import 'package:mapp/model/message.dart';
import 'package:mapp/utilities/my_date_util.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isme = Apis.user.uid == widget.message.fromid;
    return InkWell(
      onLongPress: () {
        _showBottomsheet(isme);
      },
      child: isme ? _greenmessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    if (widget.message.read.isNotEmpty) {
      Apis.updateMessageReadstatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 3 : 4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 188, 217, 241),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            MyDateUtil.getformattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getformattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 3 : 4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 168, 243, 169),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black87),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomsheet(bool isme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            ),
            // widget.message.type == Type.text
            //     ? _optionitem(
            //         icon: Icon(
            //           Icons.copy_all_rounded,
            //           color: Colors.blue,
            //           size: 26,
            //         ),
            //         name: 'copy',
            //         ontap: () async {
            //           await Clipboard.setData(
            //                   ClipboardData(text: widget.message.msg))
            //               .then(
            //             (value) {
            //               Navigator.pop(context);
            //               Dialoges.showSnackbar(context, 'Text copied');
            //             },
            //           );
            //         })
            //     : _optionitem(
            //         icon: Icon(
            //           Icons.download_rounded,
            //           color: Colors.blue,
            //           size: 26,
            //         ),
            //         name: 'Save Image',
            //         ontap: () async {
            //           try {
            //             log('imageurl:${widget.message.msg}');
            //             await GallerySaver.saveImage(widget.message.msg,
            //                     albumName: 'Mapp')
            //                 .then((success) {
            //               Navigator.pop(context);
            //               if (success != null && success) {
            //                 Dialoges.showSnackbar(
            //                     context, 'Text successfully saved!');
            //               }
            //             });
            //           } catch (e) {
            //             log('ErrorwhileSavingimg:$e');
            //           }
            //         }),
            const Divider(
              color: Colors.black54,
              endIndent: 10,
              indent: 10,
            ),
            if (widget.message.type == Type.text && isme)
              _optionitem(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Edit message',
                  ontap: () {
                    Navigator.pop(context);
                    _showMessageUpdateDialog();
                  }),
            if (isme)
              _optionitem(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: 'Delete message',
                  ontap: () {
                    Apis.deleteMessage(widget.message).then(
                      (value) {
                        Navigator.pop(context);
                      },
                    );
                  }),
            const Divider(
              color: Colors.black54,
              endIndent: 10,
              indent: 10,
            ),
            _optionitem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                ),
                name:
                    'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                ontap: () {}),
            _optionitem(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                name: widget.message.read.isEmpty
                    ? 'Read At : Not seen yet'
                    : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                ontap: () {}),
          ],
        );
      },
    );
  }

  void _showMessageUpdateDialog() {
    String updatedmsg = widget.message.msg;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text('Update Message')
          ],
        ),
        content: TextFormField(
          initialValue: updatedmsg,
          maxLines: null,
          onChanged: (value) => updatedmsg = value,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              Apis.updateMessage(widget.message, updatedmsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _optionitem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback ontap;
  const _optionitem(
      {required this.icon, required this.name, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ontap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '   $name',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
