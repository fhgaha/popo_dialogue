RSRC                 	   Resource            �+Y;�qx
   GraphData                                                   resource_local_to_scene    resource_name    script    speaker_name    text    options    name    offset 	   variable 	   operator    value    value1    value2    scroll_offset    connections    nodes 
   variables       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script L   res://addons/popochiu/editor/dialogue_graph/save_load/dialogue_node_data.gd ��������   Script I   res://addons/popochiu/editor/dialogue_graph/save_load/start_node_data.gd ��������   Script G   res://addons/popochiu/editor/dialogue_graph/save_load/set_node_data.gd ��������   Script M   res://addons/popochiu/editor/dialogue_graph/save_load/condition_node_data.gd ��������      local://Resource_k4dgr 1         local://Resource_xfgfg �         local://Resource_nngte          local://Resource_k07gf �         local://Resource_wf34x �      0   res://game/dialogs/first/dialog_first_graph.res �      	   Resource                         Npc          first time                exit1                 DialogueNode1    
   Đ'��C	   Resource                      
   StartNode    
   ��J���C	   Resource                          	         = 
         false       	   SetNode1    
   |O��  oC	   Resource                          	         ==          true          ConditionNode1    
   ��� ��C	   Resource                         Npc          not first time                exit2                 DialogueNode2    
   �W\���C	   Resource             dialog_first_graph.res                 
     w�  ��                  
   from_node ,   
   StartNode    
   from_port              to_node ,      ConditionNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port              to_node ,   	   SetNode1       to_port                 
   from_node ,   	   SetNode1    
   from_port              to_node ,      DialogueNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port             to_node ,      DialogueNode2       to_port                                                                              first_time             type             value       RSRC