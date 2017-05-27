Set Warnings "-notation-overridden".

Require Import Category.Lib.
Require Export Category.Theory.Functor.
Require Export Category.Functor.Bifunctor.
Require Export Category.Structure.Monoidal.
Require Export Category.Functor.Construction.Product.
Require Export Category.Instance.Fun.

Generalizable All Variables.
Set Primitive Projections.
Set Universe Polymorphism.
Unset Transparent Obligations.

Section MonoidalFunctor.

Context {C : Category}.
Context {D : Category}.
Context `{@Monoidal C}.
Context `{@Monoidal D}.
Context {F : C ⟶ D}.

Lemma ap_iso_to_from
      (ap_functor_iso : (⨂) ○ F ∏⟶ F ≅[[C ∏ C, D]] F ○ (⨂)) {X Y} :
  transform (to ap_functor_iso) (X, Y)
    ∘ transform (from ap_functor_iso) (X, Y) ≈ id[F (X ⨂ Y)].
Proof.
  pose proof (iso_to_from ap_functor_iso (X, Y)).
  simpl in *.
  rewrite !fmap_id in X0.
  apply X0.
Qed.

Lemma ap_iso_from_to
      (ap_functor_iso : (⨂) ○ F ∏⟶ F ≅[[C ∏ C, D]] F ○ (⨂)) {X Y} :
  transform (from ap_functor_iso) (X, Y) ∘ transform (to ap_functor_iso) (X, Y)
    ≈ id[((⨂) ○ F ∏⟶ F) (X, Y)].
Proof.
  pose proof (iso_from_to ap_functor_iso (X, Y)).
  simpl in *.
  rewrite !fmap_id in X0.
  apply X0.
Qed.

Class MonoidalFunctor := {
  pure_iso : I ≅ F I;

  ap_functor_iso : (⨂) ○ F ∏⟶ F ≅[[C ∏ C, D]] F ○ (⨂);

  ap_iso {X Y} : F X ⨂ F Y ≅ F (X ⨂ Y) := {|
    to   := transform[to ap_functor_iso] (X, Y);
    from := transform[from ap_functor_iso] (X, Y);
    iso_to_from := @ap_iso_to_from ap_functor_iso X Y;
    iso_from_to := @ap_iso_from_to ap_functor_iso X Y
  |};

  pure_iso_left {X}  : I ⨂ F X ≅ F (I ⨂ X);
  pure_iso_right {X} : F X ⨂ I ≅ F (X ⨂ I);

  ap_iso_assoc {X Y Z} : (F X ⨂ F Y) ⨂ F Z ≅ F (X ⨂ (Y ⨂ Z));

  monoidal_unit_left {X} :
    to unit_left
       ≈ fmap[F] (to unit_left) ∘ to ap_iso ∘ bimap (to pure_iso) (id[F X]);

  monoidal_unit_right {X} :
    to unit_right
       ≈ fmap[F] (to unit_right) ∘ to ap_iso ∘ bimap (id[F X]) (to pure_iso);

  monoidal_assoc {X Y Z} :
    fmap[F] (to (@tensor_assoc _ _ X Y Z)) ∘ to ap_iso ∘ bimap (to ap_iso) id
      ≈ to ap_iso ∘ bimap id (to ap_iso) ∘ to tensor_assoc
}.

Class LaxMonoidalFunctor := {
  lax_pure : I ~> F I;

  ap_functor_nat : ((⨂) ○ F ∏⟶ F) ~{[C ∏ C, D]}~> (F ○ (⨂));

  lax_ap {X Y} : F X ⨂ F Y ~> F (X ⨂ Y) := transform[ap_functor_nat] (X, Y);

  pure_left {X}  : I ⨂ F X ≅ F (I ⨂ X);
  pure_right {X} : F X ⨂ I ≅ F (X ⨂ I);

  ap_assoc {X Y Z} : (F X ⨂ F Y) ⨂ F Z ≅ F (X ⨂ (Y ⨂ Z));

  lax_monoidal_unit_left {X} :
    to unit_left
       ≈ fmap[F] (to unit_left) ∘ lax_ap ∘ bimap lax_pure (id[F X]);

  lax_monoidal_unit_right {X} :
    to unit_right
       ≈ fmap[F] (to unit_right) ∘ lax_ap ∘ bimap (id[F X]) lax_pure;

  lax_monoidal_assoc {X Y Z} :
    fmap[F] (to (@tensor_assoc _ _ X Y Z)) ∘ lax_ap ∘ bimap lax_ap id
      ≈ lax_ap ∘ bimap id lax_ap ∘ to tensor_assoc
}.

Program Definition MonoidalFunctor_Is_Lax (S : MonoidalFunctor) :
  LaxMonoidalFunctor := {|
  lax_pure := to (@pure_iso S);
  ap_functor_nat := to (@ap_functor_iso S)
|}.
Next Obligation. apply pure_iso_left. Qed.
Next Obligation. apply pure_iso_right. Qed.
Next Obligation. apply ap_iso_assoc. Qed.
Next Obligation. apply monoidal_unit_left. Qed.
Next Obligation. apply monoidal_unit_right. Qed.
Next Obligation. apply monoidal_assoc. Qed.

End MonoidalFunctor.

Notation "ap_iso[ F ]" := (@ap_iso _ _ _ _ F%functor _ _ _)
  (at level 9, format "ap_iso[ F ]").
Notation "ap_functor_iso[ F ]" := (@ap_functor_iso _ _ _ _ _ F%functor)
  (at level 9, format "ap_functor_iso[ F ]") : morphism_scope.

Notation "lax_pure[ F ]" := (@lax_pure _ _ _ _ F%functor _)
  (at level 9, format "lax_pure[ F ]") : morphism_scope.
Notation "lax_ap[ F ]" := (@lax_ap _ _ _ _ F%functor _ _ _)
  (at level 9, format "lax_ap[ F ]").
Notation "ap_functor_nat[ F ]" := (@ap_functor_nat _ _ _ _ _ F%functor)
  (at level 9, format "ap_functor_nat[ F ]") : morphism_scope.

Arguments LaxMonoidalFunctor {C D _ _} F.
Arguments MonoidalFunctor {C D _ _} F.
