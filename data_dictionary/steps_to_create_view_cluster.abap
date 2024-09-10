Steps to create view cluster

1.Create Two Tables with foreign key relationship.
2.Create Maintenance views for both tables.

Note:
In maintenance attribute put S in fields which we want to carry over next screens.

3.Goto Utilities and select table maintenance generator for both the views.

Table Maintenance Generator: we need to provide bellow details:

Authorization Group: we can select &NC& ie.without authorization group.
Specify Function Group: we can first create one function group & specify or directly specify the function group.
Maintenance Type: one step and specify the screen no in overview screen and click on create button.

4.Create View Cluster
tcode: se54

click on Edit View Cluster-->provide view cluster name-->click on create/change button-->maintain description
 for view cluster.

then goto to object structure and specify views which we created in view/table.generate field dependence for all objects.
 
Note: Any changes in maintenance views we have to regenerate screens using table maintenance generator 
in order to reflect in view cluster.