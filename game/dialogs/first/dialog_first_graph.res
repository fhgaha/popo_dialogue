RSRC                 	   Resource            �ܙ0��� 
   GraphData                                             	      resource_local_to_scene    resource_name    script    name    type    offset    data    connections    nodes       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script C   res://addons/popochiu/editor/dialogue_graph/save_load/node_data.gd ��������      local://Resource_jdtq2 \         local://Resource_pxqgq �         local://Resource_dcahl �         local://Resource_glmlp �         local://Resource_howhq �      	   Resource                      
   StartNode              
     �B�q��          	   Resource                         DialogueNode             
     hC����               speaker       Main       text    !   I need to ask you some questions       options             Who are you?       What are you doing here?        	   Resource                         DialogueNode2             
   �D��               speaker       Npc       text       Huh?       options          &   [shake]I'M ASKING WHO ARE YOU[/shake]    
   Nevermind        	   Resource                         DialogueNode3             
   #h DΗJ�               speaker       Npc       text       I am standing here       options              	   Resource                                   
   from_node ,   
   StartNode    
   from_port              to_node ,      DialogueNode       to_port                 
   from_node ,      DialogueNode    
   from_port              to_node ,      DialogueNode2       to_port                 
   from_node ,      DialogueNode    
   from_port             to_node ,      DialogueNode3       to_port                                                      RSRC