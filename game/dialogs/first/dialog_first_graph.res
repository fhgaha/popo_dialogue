RSRC                 	   Resource            �+Y;�qx
   GraphData                                                   resource_local_to_scene    resource_name    script    name    offset    speaker_name    text    options    value1 	   operator    value2 	   variable    value    scroll_offset    connections    nodes 
   variables       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script I   res://addons/popochiu/editor/dialogue_graph/save_load/start_node_data.gd ��������   Script L   res://addons/popochiu/editor/dialogue_graph/save_load/dialogue_node_data.gd ��������   Script M   res://addons/popochiu/editor/dialogue_graph/save_load/condition_node_data.gd ��������   Script G   res://addons/popochiu/editor/dialogue_graph/save_load/set_node_data.gd ��������      local://Resource_i1qd2 T         local://Resource_a13uo �         local://Resource_5jkqh          local://Resource_3g28j �         local://Resource_gdkyf +         local://Resource_vtge4 �      0   res://game/dialogs/first/dialog_first_graph.res 4      	   Resource                      
   StartNode    
   �����\C	   Resource                         Main          Hello!                          DialogueNode1    
   Fm�ú��B	   Resource                         Main          First time?                          DialogueNode2    
   h�D 9��	   Resource                         first_time 	         == 
         true          ConditionNode1    
   ��}����B	   Resource                         first_time 	         =          false       	   SetNode1    
   ��C���A	   Resource                         Main          Not first time                          DialogueNode3    
   ��Cn�C	   Resource             dialog_first_graph.res                 
     ���$�                  
   from_node ,   
   StartNode    
   from_port              to_node ,      DialogueNode1       to_port                 
   from_node ,      DialogueNode1    
   from_port              to_node ,      ConditionNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port              to_node ,   	   SetNode1       to_port                 
   from_node ,   	   SetNode1    
   from_port              to_node ,      DialogueNode2       to_port                 
   from_node ,      ConditionNode1    
   from_port             to_node ,      DialogueNode3       to_port                                                                                       first_time             type             value       RSRC