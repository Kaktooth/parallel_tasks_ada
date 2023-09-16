with Ada.Containers;
with Ada.Containers.Vectors;

with Ada.Text_IO; use Ada.Text_IO;

procedure parallel_sum is
   package Integer_Vectors is new Ada.Containers.Vectors (Index_Type => Natural, Element_Type => Integer);
   use Integer_Vectors;

  protected type Protected_Integer_Vector is
      procedure Append(Element : Integer);
      procedure PutLine;
      procedure Set(newVec : Integer_Vectors.Vector);
      function Length return Natural;
      function Element(Index : Natural) return Integer;
      function First_Element return Integer;
      function Last_Element return Integer;
      function Get_Elements return Integer_Vectors.Vector;
      procedure Clear;
      procedure Delete_First;
      procedure Delete_Last;

   private
      vec : Integer_Vectors.Vector;
   end Protected_Integer_Vector;

   protected body Protected_Integer_Vector is
      procedure Append(Element : Integer) is
      begin
         vec.Append(Element);
      end Append;

      function Get_Elements return Integer_Vectors.Vector is
      begin
         return vec;
      end Get_Elements;

      procedure PutLine is
      begin
         for Element of vec loop
            Put(Element'Img & " ");
         end loop;
      end PutLine;

      procedure Delete_First is
      begin
         vec.Delete_First;
      end Delete_First;

      procedure Delete_Last is
      begin
         vec.Delete_Last;
       end Delete_Last;

      procedure Set(newVec : Integer_Vectors.Vector) is
      begin
         vec := newVec;
      end Set;

      function Length return Natural is
      begin
         return Natural(vec.Length);
      end Length;

      function First_Element return Integer is
      begin
         return vec.First_Element;
      end First_Element;

      function Last_Element return Integer is
      begin
         return vec.Last_Element;
      end Last_Element;

      function Element(Index : Natural) return Integer is
      begin
         return vec.Element(Index);
      end Element;

      procedure Clear is
      begin
         vec.Clear;
      end Clear;
   end Protected_Integer_Vector;

   vector : Protected_Integer_Vector;
   resultVector : Protected_Integer_Vector;
   nextLength : Integer;
   lastIndex : Integer;
   sum : Integer;
   haveNoPair : Integer;

   task T is
      entry NewTask;
   end T;

   task body T is
   begin
      accept NewTask  do
         for J in 1 .. 5 loop

         exit when vector.Length = 1;
         nextLength := (Integer(vector.Length) + 1) / 2;

         vector.PutLine;

         for I in 1 .. nextLength loop
               haveNoPair := Integer(vector.Length) mod 2;

            if vector.Length = 1 then
                  resultVector.Append( vector.First_Element);
            else
               sum := vector.First_Element + vector.Last_Element;
               resultVector.Append(sum);
               vector.Delete_First;
               vector.Delete_Last;
            end if;
         end loop;

         Put(" --> ");
         resultVector.PutLine;
         Put("|| then ||");

         vector.Set(resultVector.Get_Elements);
            resultVector.Clear;
            end loop;
       end NewTask;
   end T;
begin
   for I in 1 .. 29 loop
         vector.Append (I);
   end loop;

   T.NewTask;

   Put_Line ("Complete");
end parallel_sum;
