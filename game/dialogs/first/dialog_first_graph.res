RSRC                 	   Resource            �+Y;�qx
   GraphData                                                   resource_local_to_scene    resource_name    script    value1 	   operator    value2    name    offset    size 	   variable    value    speaker_name    text    options    scroll_offset    connections    nodes 
   variables       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script M   res://addons/popochiu/editor/dialogue_graph/save_load/condition_node_data.gd ��������   Script G   res://addons/popochiu/editor/dialogue_graph/save_load/set_node_data.gd ��������   Script L   res://addons/popochiu/editor/dialogue_graph/save_load/dialogue_node_data.gd ��������   Script I   res://addons/popochiu/editor/dialogue_graph/save_load/start_node_data.gd ��������      local://Resource_bl8in ]         local://Resource_e016y �         local://Resource_y284q q         local://Resource_kolg4 �         local://Resource_tc8ld �         local://Resource_1kd3q       0   res://game/dialogs/first/dialog_first_graph.res f      	   Resource                         first_time          ==                    ConditionNode1    
   2���b��   
     "C  /C	   Resource                                   ==                    ConditionNode2    
   e�U�^�k�   
     7C  /C	   Resource                	                   = 
                	   SetNode1    
     <C  `�   
     C  C	   Resource                         Main                          asdf                 DialogueNode1    
     �C  ��   
     �C  pC	   Resource                                   ==                    ConditionNode4    
     ,�  /C   
     %C  /C	   Resource                      
   StartNode    
    @)�  B   
           	   Resource             dialog_first_graph.res                 
    �<�  ��                  
   from_node ,   
   StartNode    
   from_port              to_node ,      ConditionNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port              to_node ,      ConditionNode2       to_port                 
   from_node ,      ConditionNode2    
   from_port              to_node ,   	   SetNode1       to_port                 
   from_node ,   	   SetNode1    
   from_port              to_node ,      DialogueNode1       to_port                                                                                       first_time             type             value       RSRC