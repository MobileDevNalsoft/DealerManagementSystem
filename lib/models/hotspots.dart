import 'package:dms/logger/logger.dart';

class Hotspot{
  Map<String, dynamic> data;
  Hotspot? prev;
  Hotspot? next;
  Hotspot({required this.data});
}

class DoublyLinkedHotspots {
  Hotspot? head;
  Hotspot? tail;

  DoublyLinkedHotspots() {
    head = null;
    tail = null;
  }

  void addHotspot(Map<String,dynamic> data){
    Hotspot newHotspot = Hotspot(data: data);
    if(tail == null){
      head = newHotspot;
      tail = newHotspot;
    }else{
      tail!.next = newHotspot;
      newHotspot.prev = tail!;
      tail = newHotspot;
    }
  }

  Hotspot? deleteHotspotAndReturn(Map<String,dynamic> data){
    if(head == null){
      Error();
      Log.e("List is Empty");
    }

    if(head!.data == data){
      head = head!.next;
      if(head != null){
        head!.prev = null;
      }
      return head;
    }

    Hotspot? curr = head!.next;
    while(curr != null){
      if(curr.data == data){
        curr.prev!.next = curr.next;
        if(curr.next != null){
          return curr.next;
        }else{
          return curr.prev;
        }
      }
      curr = curr.next;
    }
  }

  Hotspot? getNodeAtIndex(int index){
    Hotspot? curr = head;
    for(int i = 0;i < index;i++){
      curr = curr?.next;
    }
    return curr;
  }
}