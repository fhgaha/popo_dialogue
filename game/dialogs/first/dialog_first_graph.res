RSRC                 	   Resource            �+Y;�qx
   GraphData                                                   resource_local_to_scene    resource_name    script    value1 	   operator    value2    name    offset    speaker_name    text    options 	   variable    value    scroll_offset    connections    nodes 
   variables       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script M   res://addons/popochiu/editor/dialogue_graph/save_load/condition_node_data.gd ��������   Script L   res://addons/popochiu/editor/dialogue_graph/save_load/dialogue_node_data.gd ��������   Script I   res://addons/popochiu/editor/dialogue_graph/save_load/start_node_data.gd ��������   Script G   res://addons/popochiu/editor/dialogue_graph/save_load/set_node_data.gd ��������      local://Resource_5f6yy 1         local://Resource_b528n �         local://Resource_x50gx I         local://Resource_yqtr6 �         local://Resource_j0cov )      0   res://game/dialogs/first/dialog_first_graph.res �      	   Resource                         first_time          ==          true          ConditionNode1    
   p= �ҥ�C	   Resource                         Npc 	         first time 
               exit1                 DialogueNode1    
   Đ'��C	   Resource                         Npc 	         not first time 
               exit2                 DialogueNode2    
   �W1���C	   Resource                      
   StartNode    
   ��J���C	   Resource                         first_time          =          false       	   SetNode1    
   ���ô"TC	   Resource             dialog_first_graph.res                 
   �gI�  C                  
   from_node ,   
   StartNode    
   from_port              to_node ,      ConditionNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port             to_node ,      DialogueNode2       to_port                 
   from_node ,      ConditionNode1    
   from_port              to_node ,   	   SetNode1       to_port                 
   from_node ,   	   SetNode1    
   from_port              to_node ,      DialogueNode1       to_port                                                                              first_time             type             value       RSRC